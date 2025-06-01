#ifndef HACKCOMPUTERQT_H
#define HACKCOMPUTERQT_H

#include <QMainWindow>
#include <QPainter>
#include <QDebug>
#include <QGraphicsScene>

#include <time.h>

#include "ticker.h"
#include "drawer.h"
#include "hackcomputer.h"
#include "test.h"

QT_BEGIN_NAMESPACE
namespace Ui { class HackComputerQt; }
QT_END_NAMESPACE

class HackComputerQt : public QMainWindow
{
    Q_OBJECT

public:
    HackComputerQt(QWidget *parent = nullptr);
    ~HackComputerQt();
    static void simpleWait(uint32_t nanoSeconds);

public slots:
    void updateScene(QPixmap pixmap);

private:
    Ui::HackComputerQt *ui;
    HackComputer * hackComputer;
    Ticker * ticker;
    Drawer * drawer;
    QGraphicsScene * scene;
    Test * test;
};
#endif // HACKCOMPUTERQT_H
