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
	id: logTab

	property alias smsedit: _smsedit
	property alias smsSendButton: _smsSendButton
	property alias logText: logTxt

	Rectangle {
		anchors.fill: parent
		color: main.tBg
	}

	// Top bar
	Rectangle {
		id: topBar
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.topMargin: main.sp2
		anchors.leftMargin: main.sp4
		anchors.rightMargin: main.sp4
		height: 44
		color: "transparent"

		Text {
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
			text: qsTr("Debug Log")
			color: main.tText
			font.pixelSize: 18
			font.bold: true
		}

		Button {
			id: clearLogButton
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			width: 84
			height: 32
			text: qsTr("Clear")
			flat: false

			contentItem: Text {
				text: clearLogButton.text
				color: main.tAccent
				font.pixelSize: 14
				font.bold: true
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			background: Rectangle {
				color: clearLogButton.pressed ? Qt.darker(main.tAccent, 1.2) : "transparent"
				border.color: main.tAccent
				border.width: 1
				radius: main.radiusSm
			}

			onClicked: {
				logTxt.clear();
			}
		}
	}

	// Log text area card
	Rectangle {
		id: logTextBox
		anchors.top: topBar.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: smsRow.top
		anchors.topMargin: main.sp2
		anchors.leftMargin: main.sp4
		anchors.rightMargin: main.sp4
		anchors.bottomMargin: main.sp2
		color: main.tSurface
		radius: main.radius
		border.color: main.tBorder
		border.width: 1

		Flickable {
			id: logflick
			anchors.fill: parent
			anchors.margins: main.sp3
			contentWidth: parent.width
			contentHeight: logTxt.contentHeight
			flickableDirection: Flickable.VerticalFlick
			clip: true
			ScrollBar.vertical: ScrollBar {
				policy: ScrollBar.AsNeeded
			}

			TextArea {
				id: logTxt
				width: logflick.width
				height: Math.max(logflick.height, contentHeight)
				readOnly: true
				wrapMode: TextArea.WordWrap
				text: qsTr("")
				color: main.tText
				font.family: "monospace"
				font.pixelSize: 13
				background: null
				selectByMouse: true
			}
		}
	}

	// SMS section (bottom row)
	Rectangle {
		id: smsRow
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.leftMargin: main.sp4
		anchors.rightMargin: main.sp4
		anchors.bottomMargin: main.sp2 + main.safeBottom
		height: 48
		color: main.tSurface
		radius: main.radiusSm
		border.color: main.tBorder
		border.width: 1
		visible: true

		TextField {
			id: _smsedit
			anchors.left: parent.left
			anchors.verticalCenter: parent.verticalCenter
			anchors.leftMargin: main.sp3
			anchors.right: _smsSendButton.left
			anchors.rightMargin: main.sp2
			height: 36
			text: qsTr("")
			selectByMouse: true
			placeholderText: qsTr("Enter SMS message...")
			placeholderTextColor: main.tTextMuted
			color: main.tText
			font.pixelSize: 14

			background: Rectangle {
				color: main.tSurface2
				radius: main.radiusSm
				border.color: _smsedit.activeFocus ? main.tAccent : main.tBorder
				border.width: 1
			}
		}

		Button {
			id: _smsSendButton
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			anchors.rightMargin: main.sp3
			width: 72
			height: 36
			text: qsTr("Send")

			contentItem: Text {
				text: _smsSendButton.text
				color: main.tText
				font.pixelSize: 14
				font.bold: true
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			background: Rectangle {
				color: _smsSendButton.pressed ? Qt.darker(main.tAccent, 1.2) : main.tAccent
				radius: main.radiusSm
			}

			onClicked: {
				droidstar.m17_sms_pressed(smsedit.text);
				smsedit.text = "";
			}
		}
	}
}
