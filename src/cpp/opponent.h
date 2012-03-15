#ifndef OPPONENT_H
#define OPPONENT_H

#include <QObject>

class QIODevice;

class Opponent : public QObject
{
Q_OBJECT

public:
    Opponent(QObject* parent, QIODevice* socket);
public slots:
    void jewelsDestroyed(int count);
private slots:
    void readCommands();

signals:
    void unclearBlock();
    void lockBlock();

private:
    QIODevice* m_socket;
};

#endif
