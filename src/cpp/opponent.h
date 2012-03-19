#ifndef OPPONENT_H
#define OPPONENT_H

#include <QObject>

class QIODevice;
namespace QtMobility {
    class QRfcommServer;
    class QBluetoothSocket;
}

class Opponent : public QObject
{
Q_OBJECT

public:
    Opponent(QObject* parent);
    ~Opponent();

public slots:
    void waitForOpponent();
    void connectToServer(const QString &btAddr);

    void jewelsDestroyed(int count);
private slots:
    void readCommands();
    void clientConnectedOnMe();
    void clientConnectedOnServer();
    void handleSocketError();
signals:
    void opponentIsReady();
    void opponentDisconnected();
    void unclearBlock();
    void lockBlock();

private:
    QtMobility::QRfcommServer* m_server;
    QtMobility::QBluetoothSocket* m_socket;
};

#endif
