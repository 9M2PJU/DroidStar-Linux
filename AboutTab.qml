/*
	Copyright (C) 2019-2021 Doug McLain
	Modified Copyright (C) 2026 9M2PJU

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
	id: aboutTab

	Rectangle {
		id: bg
		anchors.fill: parent
		color: main.tBg

		Flickable {
			anchors.fill: parent
			contentWidth: parent.width
			contentHeight: contentColumn.y + contentColumn.height + main.sp5
			flickableDirection: Flickable.VerticalFlick
			clip: true

			Column {
				id: contentColumn
				anchors.horizontalCenter: parent.horizontalCenter
				width: Math.min(parent.width - main.sp4 * 2, 520)
				topPadding: main.sp5
				spacing: main.sp4

				// --- App logo ---
				Rectangle {
					anchors.horizontalCenter: parent.horizontalCenter
					width: 100
					height: 100
					color: main.tSurface
					radius: main.radius
					border.color: main.tBorder
					border.width: 1
					clip: true

					Image {
						anchors.fill: parent
						anchors.margins: main.sp2
						source: "qrc:/qt/qml/DroidStarApp/images/droidstar.png"
						fillMode: Image.PreserveAspectFit
						smooth: true
					}
				}

				// --- App name ---
				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "DroidStar"
					color: main.tText
					font.pixelSize: 26
					font.bold: true
				}

				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "9M2PJU Mod"
					color: main.tAccent
					font.pixelSize: 16
					font.bold: true
				}

				// --- Build info card ---
				Rectangle {
					width: parent.width
					height: buildCol.height + main.sp4 * 2
					color: main.tSurface
					radius: main.radius
					border.color: main.tBorder
					border.width: 1

					Column {
						id: buildCol
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						anchors.margins: main.sp4
						spacing: main.sp2

						Row {
							width: parent.width
							spacing: main.sp2
							Text {
								width: parent.width * 0.4
								color: main.tTextMuted
								font.pixelSize: 13
								text: "Version"
							}
							Text {
								width: parent.width * 0.6 - main.sp2
								color: main.tText
								font.pixelSize: 13
								font.bold: true
								text: droidstar.get_app_version()
							}
						}

						Row {
							width: parent.width
							spacing: main.sp2
							Text {
								width: parent.width * 0.4
								color: main.tTextMuted
								font.pixelSize: 13
								text: "Build"
							}
							Text {
								width: parent.width * 0.6 - main.sp2
								color: main.tText
								font.pixelSize: 13
								font.bold: true
								text: droidstar.get_software_build()
							}
						}

						Row {
							width: parent.width
							spacing: main.sp2
							Text {
								width: parent.width * 0.4
								color: main.tTextMuted
								font.pixelSize: 13
								text: "Platform"
							}
							Text {
								width: parent.width * 0.6 - main.sp2
								color: main.tText
								font.pixelSize: 13
								font.bold: true
								text: droidstar.get_platform()
							}
						}

						Row {
							width: parent.width
							spacing: main.sp2
							Text {
								width: parent.width * 0.4
								color: main.tTextMuted
								font.pixelSize: 13
								text: "Architecture"
							}
							Text {
								width: parent.width * 0.6 - main.sp2
								color: main.tText
								font.pixelSize: 13
								font.bold: true
								text: droidstar.get_arch()
							}
						}

						Row {
							width: parent.width
							spacing: main.sp2
							Text {
								width: parent.width * 0.4
								color: main.tTextMuted
								font.pixelSize: 13
								text: "Build ABI"
							}
							Text {
								width: parent.width * 0.6 - main.sp2
								color: main.tText
								font.pixelSize: 13
								font.bold: true
								text: droidstar.get_build_abi()
							}
						}
					}
				}

				// --- Website link ---
				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "<a href=\"https://droidstar-linux.hamradio.my\">droidstar-linux.hamradio.my</a>"
					color: main.tAccent
					linkColor: main.tAccent
					font.pixelSize: 14
					textFormat: Text.RichText
					onLinkActivated: droidstar.open_url(link)
				}

				// --- Donation buttons card ---
				Rectangle {
					width: parent.width
					height: donateCol.height + main.sp4 * 2
					color: main.tSurface
					radius: main.radius
					border.color: main.tBorder
					border.width: 1

					Column {
						id: donateCol
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						anchors.margins: main.sp4
						spacing: main.sp3

						Button {
							id: bmcBtn
							width: parent.width
							text: "Buy Me a Coffee"
							font.bold: true
							background: Rectangle {
								color: "#ffdd00"
								radius: main.radius
							}
							contentItem: Text {
								text: bmcBtn.text
								color: "#000000"
								font.bold: true
								font.pixelSize: 14
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
							}
							onClicked: droidstar.open_url("https://www.buymeacoffee.com/9m2pju")
						}

						Button {
							id: wiseBtn
							width: parent.width
							text: "Donate with Wise"
							font.bold: true
							background: Rectangle {
								color: "#9FE870"
								radius: main.radius
							}
							contentItem: Text {
								text: wiseBtn.text
								color: "#163300"
								font.bold: true
								font.pixelSize: 14
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
							}
							onClicked: droidstar.open_url("https://wise.com/pay/me/faizulz13")
						}
					}
				}

				// --- Modified by ---
				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Modified by <a href=\"https://hamradio.my\">9M2PJU</a>"
					color: main.tTextMuted
					linkColor: main.tAccent
					font.pixelSize: 13
					textFormat: Text.RichText
					onLinkActivated: droidstar.open_url(link)
				}

				// --- License ---
				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "GPL v3.0"
					color: main.tTextMuted
					font.pixelSize: 12
				}

				// --- Copyright ---
				Text {
					width: parent.width
					horizontalAlignment: Text.AlignHCenter
					wrapMode: Text.WordWrap
					color: main.tTextMuted
					font.pixelSize: 11
					text: qsTr("Copyright (C) 2019-2026 Doug McLain AD8DP\n" +
							  "Modified and distributed by 9M2PJU")
				}
			}
		}
	}
}
