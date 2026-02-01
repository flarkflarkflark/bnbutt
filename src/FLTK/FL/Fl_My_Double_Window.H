#ifndef FL_MY_DOUBLE_WINDOW_H
#define FL_MY_DOUBLE_WINDOW_H


#include <FL/x.H>
#include <FL/Fl_Double_Window.H>


#ifdef _WIN32
#include <windows.h>
#elif __APPLE__
#import <Cocoa/Cocoa.h>
#else
#include <X11/Xlib.h>
#endif


class Fl_My_Double_Window : public Fl_Double_Window {
    public:
        typedef void (*resize_cb_t)(Fl_My_Double_Window* win, void* user);

        // Optional resize callback hook (FLTK has a virtual resize(), but no signal-style callback).
        void set_resize_callback(resize_cb_t cb, void* user) {
            resize_cb_ = cb;
            resize_user_ = user;
        }

        void stay_on_top(int ontop) {
#ifdef _WIN32
            SetWindowPos(fl_xid(this), ontop ? HWND_TOPMOST : HWND_NOTOPMOST,
                    0,0,0,0, SWP_NOMOVE|SWP_NOSIZE|SWP_NOOWNERZORDER);
            
#elif __APPLE__
            
           if(ontop)
                [fl_xid(this) setLevel:NSFloatingWindowLevel];
            else
                [fl_xid(this) setLevel:NSNormalWindowLevel];
         
#else //UNIX
            XEvent e;

            Atom WM_STATE = XInternAtom(fl_display, "_NET_WM_STATE", 0);
            Atom WM_STATE_ABOVE = XInternAtom(fl_display, "_NET_WM_STATE_ABOVE", 0);

            e.xclient.type = ClientMessage;
            e.xclient.window = fl_xid(this);
            e.xclient.message_type = WM_STATE;
            e.xclient.format = 32;
            e.xclient.data.l[0] = (long)ontop;
            e.xclient.data.l[1] = (long)WM_STATE_ABOVE;
            e.xclient.data.l[2] = (long)0;
            e.xclient.data.l[3] = (long)0;
            e.xclient.data.l[4] = (long)0;

            XSendEvent(fl_display, RootWindow(fl_display, fl_screen), 0,
                    SubstructureNotifyMask|SubstructureRedirectMask, &e);
            XFlush(fl_display);
#endif
        }

        Fl_My_Double_Window(int W, int H, const char *l = 0)
            : Fl_Double_Window(W,H,l), resize_cb_(0), resize_user_(0) {}

        Fl_My_Double_Window(int X, int Y, int W, int H, const char *l = 0)
            : Fl_Double_Window(X,Y,W,H,l), resize_cb_(0), resize_user_(0) {}

        void resize(int X, int Y, int W, int H) override {
            Fl_Double_Window::resize(X, Y, W, H);
            if(resize_cb_) {
                resize_cb_(this, resize_user_);
            }
        }

        ~Fl_My_Double_Window() { hide(); }

    private:
        resize_cb_t resize_cb_;
        void* resize_user_;
};

#endif //FL_MY_DOUBLE_WINDOW_H
