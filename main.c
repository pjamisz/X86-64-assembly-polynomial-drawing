#include <stdio.h>
#include <stdlib.h>
#include <allegro.h>
#include <math.h>

#include "wielomian.h"

void draw_line(BITMAP* bmp);
void drawFunction();
void printBackground();
void printInstruction();

void setWindow();
void setColors();
void setDefaultParameters();

int windowError();
int closeWindow();
void updateWindow();

void checkKey();

BITMAP * pic;
double A, B, C, D, dx;
int white, black;
double dx_kwadrat;
int height = 1024;
int width = 1024;
int skala = 128;

int main(){
    setDefaultParameters();
    setWindow();

    if(!pic){
        windowError();
    }

    drawFunction();
    printInstruction();
    
    while(!key[ KEY_ESC ]){
        checkKey();
        updateWindow();
        readkey();
    }

    closeWindow();
}

void setWindow(){
    allegro_init();
    install_keyboard();
    set_color_depth( 24 );
    set_gfx_mode( GFX_AUTODETECT_WINDOWED, width, height, 0, 0 );
    pic = create_bitmap_ex(8, width, height); 

    setColors();
}

void setColors(){
    white = makecol(0xFF, 0xFF, 0xFF);
    black = makecol(0x0, 0x0, 0x0);
}

void draw_line(BITMAP* bmp){
    vline(bmp, width/2-1, 0, height, white);
    vline(bmp, width/2, 0, height, white);
    hline(bmp, 0, height/2-1, width, white);
    hline(bmp, 0, height/2, width, white);
}

void printBackground(){
    clear_to_color (pic, black);
    draw_line(pic);
}

void setDefaultParameters(){
    A = B = C = D = dx = 1.0;
    dx_kwadrat = dx * dx;
}

int windowError(){
    set_gfx_mode(GFX_TEXT, 0, 0, 0, 0);
    allegro_message("cannot load picture!");
    allegro_exit();
    exit(EXIT_FAILURE);
}

int closeWindow(){
    destroy_bitmap(pic);
    allegro_exit();
    exit(0);
}

void drawFunction(){
    printBackground();

    wielomian(pic->line, pic->w, pic->h, skala, A, B, C, D, dx_kwadrat);
    blit(pic, screen, 0, 0, 0, 0, pic->w, pic->h);
}

void printInstruction(){
    puts("\n");
    printf("\t INSTRUKCJA \n");
    printf("\n P - instrukcja \n");
    printf("\n ESC - wylacz program \n");
    printf("\n Rysowanie funkcji trzeciego stopnia \n");
    printf("\n Zmiana parametru a - Q i A \n");
    printf("\n Zmiana parametru b - W i S \n");
    printf("\n Zmiana parametru c - E i D \n");
    printf("\n Zmiana parametru d - R i F \n");
    printf("\n Zmiana dlugosci odcinka KEY_UP, KEY_DOWN \n");
    printf("\n Zmiana skali KEY_LEFT, KEY_RIGHT \n");  
}

void updateWindow(){
    puts("\n");
    printf("Parametr A: %0.1lf \n", A);
    printf("Parametr B: %0.1lf \n", B);
    printf("Parametr C: %0.1lf \n", C);
    printf("Parametr D: %0.1lf \n", D);
    printf("Dlugosc odcinka D: %lf \n", dx);
    int tmp=512/skala;
    printf("Skala y: <-%d , %d> \n", tmp, tmp);

    drawFunction();
}

void increase_dx(){
    if(dx <= 1.0){
        dx *= 2.0;
        dx_kwadrat = dx * dx;
    }	
}

void decrease_dx(){
    if(dx > 0.0001){
        dx /= 2.0;
        dx_kwadrat = dx * dx;
    }  
}

void increase_scale(){
    if(skala >= 32){
        skala /= 2;
    }
}

void decrease_scale(){
    if(skala <= 256){
        skala *= 2;
    }    
}

void increase_A(){
    if(A < 64.0){
        A += 0.1;
    }
}

void decrease_A(){
    if(A >- 64.0){
        A -= 0.1;
    }
}

void increase_B(){
    if(B < 64.0){
        B += 0.1;
    }
}

void decrease_B(){
    if(B > -64.0){
        B -= 0.1;
    }
}

void increase_C(){
    if(C < 64.0){
        C += 0.1;
    }
}

void decrease_C(){
    if(C > -64.0){
        C -= 0.1;
    }
}

void increase_D(){
    if(D < 64.0){
        D += 0.1;
    }
}

void decrease_D(){
    if(D > -64.0){
        D -= 0.1;
    }
}

void checkKey(){
    if(key[KEY_P]){
        printInstruction();
    }
    else if(key[KEY_UP]){
        increase_dx();
    }
    else if(key[KEY_DOWN]){
        decrease_dx();			
    }
    else if(key[KEY_RIGHT]){
        increase_scale();
    }
    else if(key[KEY_LEFT]){
        decrease_scale();	
    }
    else if(key[KEY_Q]){
        increase_A();
    }
    else if(key[KEY_A]){
        decrease_A();
    }
    else if(key[KEY_W]){
        increase_B();
    }
    else if(key[KEY_S]){
        decrease_B();
    }
    else if(key[KEY_E]){
        increase_C();
    }
    else if(key[KEY_D]){
        decrease_C();
    }
    else if(key[KEY_R]){
        increase_D();
    }
    else if(key[KEY_F]){
        decrease_D();
    }
}