#include "opponent.h"
#include <QIODevice>
#include <QDebug>

Opponent::Opponent(QObject* parent, QIODevice* socket)
    : QObject(parent), m_socket(socket)
{
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(readCommands()));
}

void Opponent::jewelsDestroyed(int count)
{
    m_socket->write((char*)&count, 1);
}

void Opponent::readCommands()
{
    QByteArray data = m_socket->readAll();
    for (int i = 0; i < data.count(); ++i) {
        if (data[i] == char(3))
            emit unclearBlock();
        else if (data[i] > char(3))
            emit lockBlock();
    }
}
