
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

struct pw_element elements[] = {
{ 1, "a",  VOWEL },
//{ 2, "ae", VOWEL | DIPTHONG },
{ 2, "ah", VOWEL | DIPTHONG },
//{ "ai", VOWEL | DIPTHONG },
{ 1, "b",  CONSONANT },
{ 1, "c",  CONSONANT },
{ 2, "ch", CONSONANT | DIPTHONG },
{ 1, "d",  CONSONANT },
{ 1, "e",  VOWEL },
//{ 2,  "ee", VOWEL | DIPTHONG },
//{ 2, "ei", VOWEL | DIPTHONG },
{ 1, "f",  CONSONANT },
{ 1, "g",  CONSONANT },
{ 2, "gh", CONSONANT | DIPTHONG | NOT_FIRST },
{ 1, "h",  CONSONANT },
{ 1, "i",  VOWEL },
//{ 2, "ie", VOWEL | DIPTHONG },
{ 1, "j",  CONSONANT },
{ 1, "k",  CONSONANT },
{ 1, "l",  CONSONANT },
{ 1, "m",  CONSONANT },
{ 1, "n",  CONSONANT },
{ 2, "ng", CONSONANT | DIPTHONG | NOT_FIRST },
{ 1, "o",  VOWEL },
{ 2, "oh", VOWEL | DIPTHONG },
//{ 2, "oo", VOWEL | DIPTHONG},
{ 1, "p",  CONSONANT },
{ 2, "ph", CONSONANT | DIPTHONG },
{ 2, "qu", CONSONANT | DIPTHONG},
{ 1, "r",  CONSONANT },
{ 1, "s",  CONSONANT },
{ 2, "sh", CONSONANT | DIPTHONG},
{ 1, "t",  CONSONANT },
{ 2, "th", CONSONANT | DIPTHONG},
{ 1, "u",  VOWEL },
{ 1, "v",  CONSONANT },
{ 1, "w",  CONSONANT },
{ 1, "x",  CONSONANT },
{ 1, "y",  CONSONANT },
{ 1, "z",  CONSONANT },
{ 1, "0",  DIGIT | NOT_FIRST},
{ 1, "1",  DIGIT | NOT_FIRST},
{ 1, "2",  DIGIT | NOT_FIRST},
{ 1, "3",  DIGIT | NOT_FIRST},
{ 1, "4",  DIGIT | NOT_FIRST},
{ 1, "5",  DIGIT | NOT_FIRST},
{ 1, "6",  DIGIT | NOT_FIRST},
{ 1, "7",  DIGIT | NOT_FIRST},
{ 1, "8",  DIGIT | NOT_FIRST},
{ 1, "9",  DIGIT | NOT_FIRST},

};

#define NUM_ELEMENTS (sizeof(elements) / sizeof (struct pw_element))

static int global_print = 0;
int64_t global_count = 0;

int64_t pw_process(char *buf, int size, int pw_length, int deny_flags, int prev, int first, int feature_flags)
{
    int i, len, flags, next_deny_flags, allow_flags;
    int64_t count = 0;
    const char  *str;

    i = 0;
    next_deny_flags = 0;
    flags = 0;
    allow_flags = 0;

    /* Time to print */
    if( pw_length == size ){
        /* At least one upper and one digit */
        if( (feature_flags & (PW_DIGITS | PW_UPPERS)) == 0 ){
            if( global_print ){
                printf("%lld %s\n",global_count, buf);
                global_print = 0;
            }
            global_count++;
            return 1;
        }
        return 0;
    }

    if( first ){
        /* Allow UPPERS */
        allow_flags |= UPPERS;
        deny_flags |= NOT_FIRST;
    }else
        /* Don't allow DIGITS in first position */
        allow_flags |= DIGIT;

    /* Don't allow CONSONANT after a CONSONANT */
    if( prev & CONSONANT ){
        deny_flags |= CONSONANT;
        allow_flags |= VOWEL;
    }else
        allow_flags |= VOWEL | CONSONANT;

    if( pw_length == size - 1 ){
        /* Don't allow DIPTHONG if is the last char to found */
        deny_flags |= DIPTHONG;

        if( (feature_flags & PW_UPPERS) &&
            ((feature_flags & PW_DIGITS) || (prev & CONSONANT)) )
            return 0;

        if( feature_flags & PW_DIGITS )
            deny_flags |= VOWEL | CONSONANT | DIPTHONG;

    }

    while( i < NUM_ELEMENTS ){
        int feature_flags_completed = feature_flags;
        int next_first = first;

        next_deny_flags = 0;

        str = elements[i].str;
        len = elements[i].len;
        flags = elements[i].flags;

        i++;

        if( flags & deny_flags )
            continue;

        if( !(flags & allow_flags) )
            continue;

        if( first )
            next_deny_flags |= DIGIT;

        /* Handle DIGIT  */
        if( flags & DIGIT ) {
            feature_flags_completed &= ~PW_DIGITS;
            next_first = 1;
        }else
            next_first = 0;


        if( flags & VOWEL ){
          /* Don't allow VOWEL followed a Vowel/Dipthong pair */
          if( (prev & VOWEL) && (flags & DIPTHONG) )
            continue;

          if( prev & VOWEL || flags & DIPTHONG )
            next_deny_flags |= VOWEL;
        }


        /*
        * OK, we found an element which matches our criteria,
        * let's do it!
        */
        strcpy(buf + pw_length, str);

        count += pw_process(buf, size, pw_length + len, next_deny_flags, flags, next_first, feature_flags_completed);

        /* Handle UPPERS */
        if( (allow_flags & UPPERS) || (flags & CONSONANT) && !(flags & DIGIT) ){
            feature_flags_completed &= ~PW_UPPERS;
            buf[pw_length] = toupper(buf[pw_length]);

            /* Restart from these uppers */
            buf[pw_length + len] = '\0';
            count += pw_process(buf, size, pw_length + len, next_deny_flags, flags | UPPERS, next_first, feature_flags_completed);
        }
    }

    return count;
}

int64_t pw_phonemes(char *buf, int size, int pw_flags)
{
    return pw_process(buf, size, 0, 0, 0, 1, pw_flags);
}

void print_current_pwd(int a)
{
    global_print = 1;
}


int main(int argc, char *argv[])
{
    char pw[11] = {0};

    int size = 5;
    int64_t count = 0;

    if( argc == 2 )
        size = atoi(argv[1]);

    signal(SIGUSR1, print_current_pwd);

    count = pw_phonemes(pw, size, PW_UPPERS | PW_DIGITS);
    fprintf(stderr, "%lld pwd generated\n", count);
    return 0;
}
