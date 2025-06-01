#include "hackcomputerqt.h"
#include "./ui_hackcomputerqt.h"

#include <iostream>


HackComputerQt::HackComputerQt(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::HackComputerQt)
{
    // Prepare the GUI
    ui->setupUi(this);
    scene = new QGraphicsScene(this);
    ui->graphicsView->setScene(scene);

    test = new Test();
//    test->pccTest();
//    test->intructionTest();
//    test->cpuTest();
//    test->aluTest();
    delete test;

    // Prepare the simulator
    hackComputer = new HackComputer();
    hackComputer->preload("Rect");
    hackComputer->ram->ram[0] = 120;

    // Create and start the threads
    ticker = new Ticker(hackComputer);
    drawer = new Drawer(scene, hackComputer);

    QObject::connect(drawer, &Drawer::pixmapUpdated,
                     this, &HackComputerQt::updateScene);

    ticker->start();
    drawer->start();

    qDebug() << "I am alive #1";
}

HackComputerQt::~HackComputerQt()
{
    delete ticker;
    delete drawer;
    delete ui;
    delete test;
}


void HackComputerQt::updateScene(QPixmap pixmap)
{
    scene->addPixmap(pixmap);
}
