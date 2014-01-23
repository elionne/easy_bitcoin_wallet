
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <signal.h>

struct pw_element {
    int len;
    const char  *str;
    int     flags;
};

/*
 * Flags for the pw_element
 */
#define CONSONANT   0x0001
#define VOWEL       0x0002
#define DIPTHONG    0x0004
#define NOT_FIRST   0x0008
#define DIGIT       0x0010
#define FIRST       0x0020
#define UPPERS      0x8000

/*
 * Flags for the pwgen function
 */
#define PW_DIGITS   0x0001  /* At least one digit */
#define PW_UPPERS   0x0002  /* At least one upper letter */
#define PW_SYMBOLS  0x0004
#define PW_AMBIGUOUS    0x0008
#define PW_NO_VOWELS    0x0010
#define PW_NO_DIPTHONG_VOWEL 0x0020

static int     global_print = 0;
static int64_t global_count = 0;
static char*   global_buffer[11] = {0};
static int     global_size = 5;

void pw_process(int pw_length, int deny_flags,
                   int prev, int first, int feature_flags);


#define strcpy(a, b) *(a) = (b)

inline void process_digits(int pw_length,
                           int deny_flags, int prev, int first,
                           int feature_flags)
{
    int i;
    int next_deny_flags = 0;
    static char* digit[] = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 0
    };


    if( deny_flags & DIGIT || first)
        return;

    feature_flags &= ~PW_DIGITS;
    for(i = 0; digit[i]; ++i){
        strcpy(global_buffer + pw_length, digit[i]);
        pw_process(pw_length + 1, next_deny_flags, DIGIT, 1, feature_flags);
    }

}

inline void process_vowels(int pw_length,
                           int deny_flags, int prev, int first,
                           int feature_flags)
{

    int i;
    int next_deny_flags = 0;
    static char* vowel[] = {
        "a", "e", "i", "o", "u", 0
    };

    if( deny_flags & VOWEL )
        return;

    if( prev & VOWEL )
        next_deny_flags |= VOWEL;

    if( first )
        next_deny_flags |= DIGIT;

    for(i = 0; vowel[i]; ++i){
        strcpy(global_buffer + pw_length, vowel[i]);
        pw_process(pw_length + 1, next_deny_flags, VOWEL, 0, feature_flags);
    }
}

inline void process_vowels_upper(int pw_length,
                                 int deny_flags, int prev, int first,
                                 int feature_flags)
{
    int i;
    int next_deny_flags = 0;
    static char* vowel_upper[] = {
        "A", "E", "I", "O", "U", 0
    };

    if( deny_flags & VOWEL )
        return;

    if( first == 0 )
        return;
    else
        next_deny_flags |= DIGIT;

    if( prev & VOWEL )
        next_deny_flags |= VOWEL;

    feature_flags &= ~PW_UPPERS;
    for(i = 0; vowel_upper[i]; ++i){
        strcpy(global_buffer + pw_length, vowel_upper[i]);
        pw_process(pw_length + 1, next_deny_flags, VOWEL, 0, feature_flags);
    }
}

inline void process_vowels_dipthong(int pw_length,
                                    int deny_flags, int prev, int first,
                                    int feature_flags)
{
    int i;
    int next_deny_flags = VOWEL;
    static char* vowel_dipthong[] = {
        "ah", "oh"/*, "ae", "ai", "ee", "ei", "ie", "oo" */, 0
    };

    if( prev & VOWEL )
        return;

    if( deny_flags & (VOWEL | DIPTHONG) )
        return;

    if( first )
        next_deny_flags |= DIGIT;

    for(i = 0; vowel_dipthong[i]; ++i){
        strcpy(global_buffer + pw_length, vowel_dipthong[i]);
        pw_process(pw_length + 2, next_deny_flags, VOWEL | DIPTHONG, 0, feature_flags);
    }
}

inline void process_vowels_dipthong_upper(int pw_length,
                                          int deny_flags, int prev, int first,
                                          int feature_flags)
{
    int i;
    int next_deny_flags = VOWEL;
    static char* vowel_dipthong_upper[] = {
        "Ah", "Oh"/*, "Ae", "Ai", "Ee", "Ei", "Ie", "Oo" */, 0
    };

    if( prev & VOWEL )
        return;

    if( deny_flags & (VOWEL | DIPTHONG) )
        return;

    if( first == 0 )
        return;
    else
        next_deny_flags |= DIGIT;

    feature_flags &= ~PW_UPPERS;
    for(i = 0; vowel_dipthong_upper[i]; ++i){
        strcpy(global_buffer + pw_length, vowel_dipthong_upper[i]);
        pw_process(pw_length + 2, next_deny_flags, VOWEL | DIPTHONG, 0, feature_flags);
    }
}

inline void process_consonants(int pw_length,
                               int deny_flags, int prev, int first,
                               int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT;
    static char* consonant[] = {
        "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "y", "z", 0
    };

    if( deny_flags & CONSONANT )
        return;

    if( first )
        next_deny_flags |= DIGIT;

    for(i = 0; consonant[i]; ++i){
        strcpy(global_buffer + pw_length, consonant[i]);
        pw_process(pw_length + 1, next_deny_flags, CONSONANT, 0, feature_flags);
    }
}

inline void process_consonants_upper(int pw_length,
                                     int deny_flags, int prev, int first,
                                     int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT;
    static char* consonant_upper[] = {
        "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "R", "S", "T", "V", "W", "X", "Y", "Z", 0
    };

    if( deny_flags & CONSONANT )
        return;

    if( first )
        next_deny_flags |= DIGIT;

    feature_flags &= ~PW_UPPERS;
    for(i = 0; consonant_upper[i]; ++i){
        strcpy(global_buffer + pw_length, consonant_upper[i]);
        pw_process(pw_length + 1, next_deny_flags, CONSONANT, 0, feature_flags);
    }
}

inline void process_consonants_dipthong(int pw_length,
                                        int deny_flags, int prev, int first,
                                        int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT;
    static char* consonant_dipthong[] = {
        "ch", "gh", "ng", "ph", "qu", "sh", "th", 0
    };

    if( (deny_flags & (CONSONANT | DIPTHONG)) || first )
        return;

    for(i = 0; consonant_dipthong[i]; ++i){
        strcpy(global_buffer + pw_length, consonant_dipthong[i]);
        pw_process(pw_length + 2, next_deny_flags, CONSONANT | DIPTHONG, 0, feature_flags);
    }
}

inline void process_consonants_dipthong_upper(int pw_length,
                                              int deny_flags, int prev, int first,
                                              int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT;
    static char* consonant_dipthong_upper[] = {
        "Ch", "Gh", "Ng", "Ph", "Qu", "Sh", "Th", 0
    };

    if( (deny_flags & (CONSONANT | DIPTHONG)) || first )
        return;

    feature_flags &= ~PW_UPPERS;
    for(i = 0; consonant_dipthong_upper[i]; ++i){
        strcpy(global_buffer + pw_length, consonant_dipthong_upper[i]);
        pw_process(pw_length + 2, next_deny_flags, CONSONANT | DIPTHONG, 0, feature_flags);
    }
}

inline void process_at_first_consonants_dipthong(int pw_length,
                                                 int deny_flags, int prev, int first,
                                                 int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT | DIGIT;
    static char* at_first_consonant_dipthong[] = {
        "ch", "ph", "qu", "sh", "th", 0
    };

    if( (deny_flags & DIPTHONG) || first == 0 )
        return;

    for(i = 0; at_first_consonant_dipthong[i]; ++i){
        strcpy(global_buffer + pw_length, at_first_consonant_dipthong[i]);
        pw_process(pw_length + 2, next_deny_flags, CONSONANT | DIPTHONG, 0, feature_flags);
    }
}

inline void process_at_first_consonants_dipthong_upper(int pw_length,
                                                       int deny_flags, int prev, int first,
                                                       int feature_flags)
{
    int i;
    int next_deny_flags = CONSONANT | DIGIT;
    static char* at_first_consonant_dipthong_upper[] = {
        "Ch", "Ph", "Qu", "Sh", "Th", 0
    };

    if( (deny_flags & DIPTHONG) || first == 0  )
        return;

    feature_flags &= ~PW_UPPERS;
    for(i = 0; at_first_consonant_dipthong_upper[i]; ++i){
        strcpy(global_buffer + pw_length, at_first_consonant_dipthong_upper[i]);
        pw_process(pw_length + 2, next_deny_flags, CONSONANT | DIPTHONG, 0, feature_flags);
    }
}

#define ALL_PARAM pw_length, deny_flags, prev, first, feature_flags

void pw_process(int pw_length, int deny_flags, int prev, int first, int feature_flags)
{

    /* Time to print */
    if( pw_length == global_size ){
        /* At least one upper and one digit */
        if( (feature_flags & (PW_DIGITS | PW_UPPERS)) == 0 ){
            if( global_print ){
                int i;
                printf("%lld ",global_count);
                for(i = 0; i < global_size; ++i)
                    printf("%s", global_buffer[i]);
                printf("\n");
                global_print = 0;
            }
            global_count++;
            return;
        }
        return;
    }

    if( pw_length == global_size - 1 ){
        deny_flags |= DIPTHONG;

        if( (feature_flags & PW_UPPERS) &&
            ((feature_flags & PW_DIGITS) || (prev & CONSONANT)) )
            return;

        if( feature_flags & PW_DIGITS )
            deny_flags |= VOWEL | CONSONANT;
    }

    process_vowels(ALL_PARAM);
    process_vowels_upper(ALL_PARAM);
    process_vowels_dipthong(ALL_PARAM);
    process_vowels_dipthong_upper(ALL_PARAM);
    process_consonants(ALL_PARAM);
    process_consonants_upper(ALL_PARAM);
    process_consonants_dipthong(ALL_PARAM);
    process_consonants_dipthong_upper(ALL_PARAM);
    process_at_first_consonants_dipthong_upper(ALL_PARAM);
    process_at_first_consonants_dipthong(ALL_PARAM);
    process_digits(ALL_PARAM);

}

void pw_phonemes(int pw_flags)
{
    pw_process(0, 0, 0, 0, pw_flags);
}

void print_current_pwd(int a)
{
    global_print = 1;
}


int main(int argc, char *argv[])
{
    global_print = 1;
    if( argc == 2 )
        global_size = atoi(argv[1]);

    signal(SIGUSR1, print_current_pwd);

    pw_phonemes(PW_UPPERS | PW_DIGITS);
    fprintf(stderr, "%lld pwd generated\n", global_count);
    return 0;
}
