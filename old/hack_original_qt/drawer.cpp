#include "drawer.h"
#include "hackcomputerqt.h"
#include "utility/default.h"
#include "qpixmap.h"

void Drawer::run()
{
    while(true) {
        draw();
        Default::simpleWait((uint64_t) 1000000000/Default::FPS);
    }
}

Drawer::Drawer(QGraphicsScene *scene, HackComputer * hackComputer)
{
    this->scene = scene;
    this->hackComputer = hackComputer;
}

void Drawer::draw()
{
    QImage img(512, 256, QImage::Format_Grayscale8);
    for(int i=0; i<512; i++) {
      //int line[256];
      for(int j=0; j<256; j++) {
        int value = hackComputer->ram->readPixel(i, j);
        img.setPixel(i, j, (value==1 ? 0 : 4294967295));
        //((img.scanLine(i))[j]) = value==1 ? 0 : 255;
      }
      //img.scanLine(i) = line;
    }

    //img.setPixel(10, 10, 4294967295);

    emit pixmapUpdated(QPixmap::fromImage(img));
    //qDebug() << "Draw";
    //scene->addPixmap(QPixmap::fromImage(img));
}
