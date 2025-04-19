// I release this to public domain. If public domain doesn't work in your jusrisdiction,
// or any reason of your choosing, I alternitively licence under MIT:

// Copyright © 2024 Spider Forrest
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// stvoid gcc -lX11 -lImlib2 ~/bin/loz.c -o ~/bin/loz.bin

#define _POSIX_C_SOURCE 199309L

#include <Imlib2.h>
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define S_NS *1000000000 // convert seconds to nanoseconds
#define MS_NS *1000000 // convert milliseconds to nanoseconds
/* #define S_US *1000000 // seconds to microseconds */

int frame_delay = 40000000; // framerate ns
/* int frame_delay = 4000; // framerate us */
int current_screen = 0; // hardcode is fine, screens aren't real


uint64_t get_ns() {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC_RAW, &now); // best 'time elapsed' counter
  uint64_t ns = ((uint64_t)now.tv_sec S_NS) + (uint64_t)now.tv_nsec; // combine seconds and nanoseconds
  return ns;
}


int main() {
  // bind display and window
  Display *display = XOpenDisplay(NULL);
  Window root = RootWindow(display, 0);

  // get visual info
  XVisualInfo visual;
  XMatchVisualInfo(display, current_screen, 32, TrueColor, &visual);

  const int cm = DefaultColormap(display, current_screen);

  // configure window
  XSetWindowAttributes attr;
  attr.background_pixel  = 0; // completely transparent
  attr.colormap = XCreateColormap(display, root, visual.visual, AllocNone);
  attr.background_pixmap = None;
  attr.border_pixel = 0;
  attr.override_redirect = True;
  long attr_mask = (CWBackPixmap | CWBackPixel | CWBorderPixel | CWColormap); // super dunno honestly

  // spawn it
  Window window = XCreateWindow(
    display, root, // display, parent
    0, 0, 800, 600, 0, // x,y,w,h,border_width
    32, InputOutput, visual.visual, // depth, class, visual
    attr_mask, &attr // valuemask, attributes
  );
  XStoreName(display, window, "Tenny!!!");
  // show window
  XMapWindow(display, window);
  XFlush(display);



  // process multi-frame
  // get first img
  Imlib_Image proto_frame = imlib_load_image_frame("/home/spider/loz/yay.gif", 1);
  imlib_context_set_image(proto_frame);
  // get metadata
  Imlib_Frame_Info frame_info;
  imlib_image_get_frame_info(&frame_info);
  if (frame_info.frame_count < 1)
    fprintf(stdout, "no frames? says %d\n", frame_info.frame_count);
  int x = frame_info.frame_x; int y = frame_info.frame_y; int w = frame_info.frame_w; int h = frame_info.frame_h;
  // store every frame
  typedef struct {
    Imlib_Image image;
    Imlib_Frame_Info info;
  } Frame;
  Frame *frames = malloc(sizeof(Frame) * frame_info.frame_count);
  for (int i = 0; i < frame_info.frame_count; i++) {
    // i think this loads a copy of the image for every frame uhhh
    // todo: make not awful
    // speaking of i am never using imlib again zero docs exist past the .h file which isn't great itself
    frames[i].image = imlib_load_image_frame("/home/spider/loz/yay.gif", i+1);
    imlib_image_get_frame_info(&frames[i].info);
  }

  // insane. without this line somewhere it freezes???? help. help. hhelp
  Imlib_Frame_Info whatthefuck_completely_unused_what = frames[1000].info;

  // default framerate to given by file
  frame_delay = frame_info.frame_delay MS_NS; // ns / ms
  fprintf(stdout, "framerate in ms, ns: %d, %d\n", frame_info.frame_delay, frame_delay);

  // create and configure the context
  Imlib_Context *context = imlib_context_new();
  imlib_context_push(context);
  // create a canvas draw on
  Imlib_Image canvas = imlib_create_image(w,h);
  imlib_context_set_image(canvas);
  imlib_context_set_display(display);
  imlib_context_set_visual(visual.visual);
  imlib_context_set_colormap(cm);
  imlib_context_set_drawable(window);
  imlib_context_set_color_range(imlib_create_color_range());
  imlib_context_set_operation(IMLIB_OP_ADD); // slightly faster operation IF 100% transparent background
  imlib_context_set_blend(0);

  // main render loop
  uint64_t target = 0; // for saving the time target for stepping, to see error
  for (int i = 0; ;++i) {
    // pick frame of gif
    int current_frame = i % frame_info.frame_count;

    // edit the canvas
    /* imlib_context_set_image(canvas); */
    imlib_image_set_has_alpha(0); // uneeded for now, might be faster without
    imlib_image_clear(); // blank the canvas to black


    /* imlib_context_set_color((i+100)%255, i%255, (i+200)%255, 66); // ooh ooh oowawawa */
    /* imlib_image_fill_rectangle(x, y, w, h); // draw the canvas background */

    imlib_context_set_blend(1);
    imlib_blend_image_onto_image(frames[current_frame].image, 0, x,y,w,h, x,y,w,h); // draw the frame onto the canvas
    imlib_context_set_blend(0); // disable blending to overwrite the last frame

    // the alpha channel is a mess right now, so restore it from the frame
    imlib_image_copy_alpha_to_image(frames[current_frame].image, 0, 0);

    /* imlib_image_set_has_alpha(0); // uneeded for now, might be faster without */

    XClearWindow(display, root); // ...not sure, actually

    /* resize with window
    int x, y;
    unsigned int w, h, border_width, depth;
    Window _;
    XGetGeometry(display, window, &_, &x, &y, &w, &h, &border_width, &depth);
    imlib_render_image_on_drawable_at_size(0,0, w, h); // draw, resize
    */

    imlib_render_image_on_drawable(0,0); // draw

    XClearWindow(display, root); // ...not sure, actually
    // finish rendering
    XFlush(display);
    XSync(display, False);



    // sleep to next frame, don't allow error to compound but it's fine if one frame is off
    struct timespec delay;
    uint64_t now = get_ns();
    signed int error = target - now; // check how off from the target time we are
    target = now + frame_delay; // set the next target timestamp

    delay.tv_nsec = frame_delay + error; // create the delay, add error
    nanosleep(&delay, NULL); // aaand sleep

    /* fprintf(stdout, "? says %d\n", error); */
  }


  exit(0);
}
