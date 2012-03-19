/*
  Copyright 2012 Mats Sjöberg
  
  This file is part of the Heebo programme.
  
  Heebo is free software: you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  Heebo is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
  License for more details.
  
  You should have received a copy of the GNU General Public License
  along with Heebo.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "gameview.h"
#include "opponent.h"

#include <QDeclarativeEngine>
#include <QGraphicsObject>
#include <QTcpServer>
#include <QTcpSocket>

//------------------------------------------------------------------------------

GameView::GameView(QWidget* parent) : QDeclarativeView(parent) {
  readSettings();

  m_mapset = new GameMapSet(":/map.dat", m_level, this);
  connect(m_mapset, SIGNAL(levelChanged()), this, SLOT(onLevelChanged()));

  m_opponent = new Opponent(this);
  rootContext()->setContextProperty("mapset", m_mapset);
  rootContext()->setContextProperty("gameview", this);
  rootContext()->setContextProperty("opponent", m_opponent);

  setSource(QUrl("qrc:///qml/main.qml"));
}

//------------------------------------------------------------------------------

QString GameView::platform() const {
#ifdef HARMATTAN
  return "harmattan";
#else
  return "desktop";
#endif
}

//------------------------------------------------------------------------------

void GameView::onLevelChanged() {
  writeSettings();
}

//------------------------------------------------------------------------------

void GameView::writeSettings() {
  QSettings s("heebo", "heebo");
  s.beginGroup("Mapset");
  s.setValue("level", m_mapset->level());
  s.endGroup();
}

//------------------------------------------------------------------------------

void GameView::readSettings() {
  QSettings s("heebo", "heebo");
  s.beginGroup("Mapset");
  m_level = 0;//s.value("level", 0).toInt();
  s.endGroup();
}

QIODevice* GameView::setupTcpNetwork()
{
    // FIXME: A Ui should exist for this! cmd line is nonsense!!!
    QStringList args = QCoreApplication::instance()->arguments();
    if (args.contains("--server")) {
        QTcpServer* m_server = new QTcpServer(this);
        qDebug() << "I'm the server! waiting for clients...";
        m_server->listen(QHostAddress::Any, 1234);
        if (m_server->waitForNewConnection(-1)) {
            // FIXME: close the server!!!
            return m_server->nextPendingConnection();
        }
    } else if (args.count() > 1){
        QHostAddress addr(args[1]);
        qDebug() << "I'm the client! going to " << addr;
        QTcpSocket* socket = new QTcpSocket(this);
        socket->connectToHost(addr, 1234);
        if (socket->waitForConnected())
            return socket;
    } else {
        qFatal("wrong args... blah!");
    }
    return 0;
}
