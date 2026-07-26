/*
	Copyright (C) 2019-2021 Doug McLain

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick.Controls

Item {
	id: hostsTab
	property alias hostsTextEdit: hostsTxtEdit

	Rectangle {
		id: bg
		anchors.fill: parent
		color: main.tBg

		// Header
		Text {
			id: headerText
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: main.sp4
			wrapMode: Text.WordWrap
			color: main.tText
			font.bold: true
			font.pixelSize: 20
			text: qsTr("Custom Hosts")
		}

		// Instructions card
		Rectangle {
			id: instrCard
			anchors.top: headerText.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: main.sp4
			color: main.tSurface
			radius: main.radiusSm
			border.color: main.tBorder
			border.width: 1
			implicitHeight: instrText.implicitHeight + main.sp4 * 2

			Text {
				id: instrText
				anchors.fill: parent
				anchors.margins: main.sp4
				wrapMode: Text.WordWrap
				color: main.tTextMuted
				font.pixelSize: 13
				text: qsTr("Custom hostfile format:\n" +
						   "<mode> <name> <host> <port> <username (optional)> <password (optional)>\n" +
						   "Example: REF REF123 192.168.1.1 20001\n" +
						   "Example: DMR MyNet 192.168.1.1 62030 passw0rd\n" +
						   "Example: IAX 12345 192.168.1.1 4569 iaxclient iaxpass\n" +
						   "Example: IAX 12345 wt\n" +
						   "Example: IAX 12345 wt 4570")
			}
		}

		// Save button
		Button {
			id: saveBtn
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: main.sp4
			implicitHeight: 52

			background: Rectangle {
				color: saveBtn.pressed ? Qt.darker(main.tAccent, 1.2) : main.tAccent
				radius: main.radius
			}

			contentItem: Text {
				text: qsTr("Save")
				color: main.tBg
				font.bold: true
				font.pixelSize: 16
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			onClicked: {
				droidstar.update_custom_hosts(hostsTxtEdit.text);
			}
		}

		// Editor card - fills space between instructions and save button
		Rectangle {
			id: editorCard
			anchors.top: instrCard.bottom
			anchors.bottom: saveBtn.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.margins: main.sp4
			color: main.tSurface
			radius: main.radius
			border.color: main.tBorder
			border.width: 1
			clip: true

			Flickable {
				anchors.fill: parent
				anchors.margins: 1
				contentWidth: parent.width
				contentHeight: hostsTxtEdit.y + hostsTxtEdit.height
				flickableDirection: Flickable.VerticalFlick
				clip: true

				TextArea {
					id: hostsTxtEdit
					x: 0
					y: 0
					width: editorCard.width - 2
					height: Math.max(editorCard.height - 2, contentHeight)
					wrapMode: TextArea.WordWrap
					font.family: "monospace"
					font.pixelSize: 14
					text: qsTr("")
					background: Rectangle {
						color: "transparent"
					}
				}
			}
		}
	}
}
