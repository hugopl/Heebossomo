#include "opponent.h"
#include <QRfcommServer>
#include <QDebug>

#define SERVER_PORT 27

Opponent::Opponent(QObject* parent)
    : QObject(parent), m_server(0), m_socket(0)
{
}

Opponent::~Opponent()
{
    delete m_server;
    m_server = 0;
    delete m_socket;
    m_socket = 0;
}

void Opponent::waitForOpponent()
{
//    emit opponentIsReady();
//    return;
    // Start a l2cap server
    using namespace QtMobility;

    if (m_server)
        return;

    qCritical() << "waiting for opponent...";
    m_server = new QRfcommServer(this);
    m_server->setSecurityFlags(QBluetooth::NoSecurity);
    connect(m_server, SIGNAL(newConnection()), this, SLOT(clientConnectedOnMe()));
    m_server->listen(QBluetoothAddress(), SERVER_PORT);
}

void Opponent::connectToServer(const QString& btAddr)
{
    qCritical() << "Connecting to " << btAddr;
    using namespace QtMobility;

    m_socket = new QBluetoothSocket(QBluetoothSocket::RfcommSocket, this);
    connect(m_socket, SIGNAL(error(QBluetoothSocket::SocketError)), this, SIGNAL(opponentDisconnected()));
    connect(m_socket, SIGNAL(connected()), this, SLOT(clientConnectedOnServer()));
    m_socket->connectToService(QBluetoothAddress(btAddr), SERVER_PORT);
}

void Opponent::handleSocketError() {
    qCritical() << "ERROR: " << m_socket->errorString();
}

void Opponent::clientConnectedOnServer()
{
    qCritical() << "Conectei no servidor!!";
//    delete m_l2capServer;
//    m_l2capServer = 0;
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(readCommands()));
    emit opponentIsReady();
}

void Opponent::clientConnectedOnMe()
{
    qCritical() << "Conectaram em mim!!";
    m_socket = m_server->nextPendingConnection();
    m_socket->setParent(this);
    connect(m_socket, SIGNAL(error(QBluetoothSocket::SocketError)), this, SIGNAL(opponentDisconnected()));
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(readCommands()));
    emit opponentIsReady();
}

void Opponent::jewelsDestroyed(int count)
{
    Q_ASSERT(m_socket);
    m_socket->write((char*)&count, 1);
}

void Opponent::readCommands()
{
    QByteArray data = m_socket->readAll();
    for (int i = 0; i < data.count(); ++i) {
        int value = data[i];
        // block attack!
        if (value > 0) {
            emit unclearBlock();
            if (value > 3) {
                for (int i = 0, max = value - 3; i < max; ++i)
                    emit lockBlock();
            }
        } else {
            qCritical() << "value: " << value;
        }
    }
}
