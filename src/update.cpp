#include <stdio.h>
#include <string.h>

#include "config.h"
#include "update.h"
#include "sockfuncs.h"
#include "url.h"

char new_version[16];
char BUTTM_text[1024];

int update_check_for_new_version(void)
{
    int ret;
    char response[1024];

    memset(new_version, 0, sizeof(new_version));

    ret = url_get("https://buttm.app/latest_butt", NULL, response, sizeof(response));

    if (ret <= 0) {
        return UPDATE_ILLEGAL_ANSWER;
    }

    response[ret] = '\0';

    char *p = strstr(response, "version: ");
    if (p == NULL) {
        return UPDATE_ILLEGAL_ANSWER;
    }

    p += strlen("version: ");

    if (p[strlen(p) - 1] == '\n') {
        p[strlen(p) - 1] = '\0';
    }

    const char *cur = VERSION;
    if (cur[0] == 'v' || cur[0] == 'V') {
        cur++;
    }

    const char *new_ver = p;
    if (new_ver[0] == 'v' || new_ver[0] == 'V') {
        new_ver++;
    }

    int major_cur, minor_cur, patch_cur;
    int major_new, minor_new, patch_new;
    if (sscanf(cur, "%d.%d.%d", &major_cur, &minor_cur, &patch_cur) != 3) {
        return UPDATE_ILLEGAL_ANSWER;
    }
    if (sscanf(new_ver, "%d.%d.%d", &major_new, &minor_new, &patch_new) != 3) {
        return UPDATE_ILLEGAL_ANSWER;
    }

    if ((major_new > major_cur) || (major_new == major_cur && minor_new > minor_cur) ||
        (major_new == major_cur && minor_new == minor_cur && patch_new > patch_cur)) {
        snprintf(new_version, sizeof(new_version) - 1, "%s", p);
        return UPDATE_NEW_VERSION;
    }

    return UPDATE_UP_TO_DATE;
}

int update_check_for_BUTTM(void)
{
    int ret;
    char response[1024];

    memset(BUTTM_text, 0, sizeof(BUTTM_text));

    ret = url_get("https://buttm.app/buttm_available", NULL, response, sizeof(response));
    if (ret <= 0) {
        return UPDATE_ILLEGAL_ANSWER;
    }
    response[ret] = '\0';

    char *p = strstr(response, "BUTTM:\n");
    if (p == NULL) {
        return UPDATE_ILLEGAL_ANSWER;
    }

    p += strlen("BUTTM:\n");

    snprintf(BUTTM_text, sizeof(BUTTM_text) - 1, "%s", p);
    return UPDATE_BUTTM_AVAILABLE;
}
char *update_get_version(void)
{
    return new_version;
}

char *update_get_BUTTM_text(void)
{
    return BUTTM_text;
}
