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
	id: settingsTab

	property alias callsignEdit: csedit
	property alias dmridEdit: dmridedit
	property alias comboEssid: comboessid
	property alias bmpwEdit: bmpwedit
	property alias tgifpwEdit: tgifpwedit
	property alias aslpwEdit: aslpwedit
	property alias latEdit: latedit
	property alias lonEdit: lonedit
	property alias locEdit: locedit
	property alias descEdit: descedit
	property alias urlEdit: urledit
	property alias swidEdit: swidedit
	property alias pkgidEdit: pkgidedit
	property alias dmroptsEdit: dmroptsedit
	property alias m173200: m17_3200
	property alias m171600: m17_1600
	property alias mycallEdit: mycalledit
	property alias urcallEdit: urcalledit
	property alias rptr1Edit: rptr1edit
	property alias rptr2Edit: rptr2edit
	property alias usrtxtEdit: usrtxtedit
	property alias txtimerEdit: txtimeredit
	property alias toggleTX: toggletx
	property alias xrf2ref: xrf2Ref
	property alias ipv6: ipV6
	property alias comboVocoder: _comboVocoder
	property alias comboModem: _comboModem
	property alias comboPlayback: _comboPlayback
	property alias comboCapture: _comboCapture
	property alias modemRXFreqEdit: _modemRXFreqEdit
	property alias modemTXFreqEdit: _modemTXFreqEdit
	property alias modemRXOffsetEdit: _modemRXOffsetEdit
	property alias modemTXOffsetEdit: _modemTXOffsetEdit
	property alias modemRXDCOffsetEdit: _modemRXDCOffsetEdit
	property alias modemTXDCOffsetEdit: _modemTXDCOffsetEdit
	property alias modemRXLevelEdit: _modemRXLevelEdit
	property alias modemTXLevelEdit: _modemTXLevelEdit
	property alias modemRFLevelEdit: _modemRFLevelEdit
	property alias modemTXDelayEdit: _modemTXDelayEdit
	property alias modemCWIdTXLevelEdit: _modemCWIdTXLevelEdit
	property alias modemDStarTXLevelEdit: _modemDStarTXLevelEdit
	property alias modemDMRTXLevelEdit: _modemDMRTXLevelEdit
	property alias modemYSFTXLevelEdit: _modemYSFTXLevelEdit
	property alias modemP25TXLevelEdit: _modemP25TXLevelEdit
	property alias modemNXDNTXLevelEdit: _modemNXDNTXLevelEdit
	property alias modemBaudEdit: _modemBaudEdit
	property alias mmdvmBox: _mmdvmBox
	property alias debugBox: _debugBox

	// Helper component for a settings row
	Component {
		id: settingRow
		Row {
			spacing: main.sp2
			height: 40
		}
	}

	Rectangle {
		anchors.fill: parent
		color: main.tBg
	}

	Flickable {
		anchors.fill: parent
		contentWidth: parent.width
		contentHeight: settingsCol.height
		flickableDirection: Flickable.VerticalFlick
		clip: true
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

		Column {
			id: settingsCol
			width: parent.width
			spacing: main.sp2
			padding: main.sp2
			bottomPadding: main.sp5

			// === AUDIO / DEVICE CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: audioCol.height + main.sp4 * 2

				Column {
					id: audioCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "AUDIO DEVICE"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "Vocoder"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						ComboBox {
							id: _comboVocoder
							width: parent.width - 80 - main.sp2
							height: 36
							onCurrentIndexChanged: {
								if (currentText.length > 0)
									droidstar.set_vocoder(currentText)
							}
						}
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "Modem"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						ComboBox { id: _comboModem; width: parent.width - 80 - main.sp2; height: 36 }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "Playback"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						ComboBox { id: _comboPlayback; width: parent.width - 80 - main.sp2; height: 36 }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "Capture"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						ComboBox { id: _comboCapture; width: parent.width - 80 - main.sp2; height: 36 }
					}
				}
			}

			// === IDENTITY CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: idCol.height + main.sp4 * 2

				Column {
					id: idCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "IDENTITY"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "Callsign"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: csedit; width: parent.width - 80 - main.sp2; height: 36; font.capitalization: Font.AllUppercase; selectByMouse: true }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "DMRID"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: dmridedit; width: 120; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "ESSID"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						ComboBox {
							id: comboessid
							width: 100; height: 36
							function build_model(){
								var ids = ["None"];
								for(var i = 0; i < 100; ++i){
									ids[i+1] = i.toString().padStart(2, "0");
								}
								comboessid.model = ids;
								comboessid.currentIndex = comboessid.find(droidstar.get_essid());
							}
							Component.onCompleted: build_model();
						}
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "BM Pass"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: bmpwedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; echoMode: TextInput.Password }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "TGIF Pass"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: tgifpwedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; echoMode: TextInput.Password }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "ASL Pass"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: aslpwedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; echoMode: TextInput.Password }
					}
				}
			}

			// === LOCATION / APRS CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: locCol.height + main.sp4 * 2

				Column {
					id: locCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "LOCATION / APRS"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row { width: parent.width; spacing: main.sp2
						Text { text: "Latitude"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: latedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "Longitude"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: lonedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "Location"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: locedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "Description"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: descedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "URL"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: urledit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "SoftwareID"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: swidedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "PackageID"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: pkgidedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
				}
			}

			// === DSTAR / DMR CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: dstarCol.height + main.sp4 * 2

				Column {
					id: dstarCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "DSTAR / DMR"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row { width: parent.width; spacing: main.sp2
						Text { text: "DMR+ Opts"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: dmroptsedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "MYCALL"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: mycalledit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; font.capitalization: Font.AllUppercase; onEditingFinished: droidstar.set_mycall(mycalledit.text.toUpperCase()) }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "URCALL"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: urcalledit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; font.capitalization: Font.AllUppercase; onEditingFinished: droidstar.set_urcall(urcalledit.text.toUpperCase()) }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RPTR1"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: rptr1edit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; font.capitalization: Font.AllUppercase; onEditingFinished: droidstar.set_rptr1(rptr1edit.text.toUpperCase()) }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RPTR2"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: rptr2edit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; font.capitalization: Font.AllUppercase; onEditingFinished: droidstar.set_rptr2(rptr2edit.text.toUpperCase()) }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "USRTXT"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: usrtxtedit; width: parent.width - 80 - main.sp2; height: 36; selectByMouse: true; onEditingFinished: droidstar.set_usrtxt(usrtxtedit.text) }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "TX Timeout"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: txtimeredit; width: 120; height: 36; selectByMouse: true }
					}
					Row {
						width: parent.width
						spacing: main.sp2
						Text { text: "M17/YSF rate"; color: main.tTextMuted; font.pixelSize: 13; width: 100; verticalAlignment: Text.AlignVCenter }
						ButtonGroup {
							id: m17rateGroup
							onClicked: {
								button.text === "Voice Full" ? droidstar.m17_rate_changed(true) : droidstar.m17_rate_changed(false)
							}
						}
						CheckBox { id: m17_3200; height: 36; spacing: 1; text: qsTr("Voice Full"); checked: true; ButtonGroup.group: m17rateGroup }
						CheckBox { id: m17_1600; height: 36; spacing: 1; text: qsTr("Voice/Data"); ButtonGroup.group: m17rateGroup }
					}
				}
			}

			// === OPTIONS / UPDATES CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: optCol.height + main.sp4 * 2

				Column {
					id: optCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "OPTIONS"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row {
						width: parent.width
						spacing: main.sp2
						Button {
							id: updateHostsBtn
							width: (parent.width - main.sp2) / 2
							height: 40
							text: qsTr("Update Hosts")
							background: Rectangle { color: main.tAccent; radius: main.radiusSm }
							contentItem: Text { text: updateHostsBtn.text; color: main.tBg; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
							onClicked: { droidstar.update_host_files(); updateDialog.open() }
						}
						Button {
							id: updateIdsBtn
							width: (parent.width - main.sp2) / 2
							height: 40
							text: qsTr("Update ID Files")
							background: Rectangle { color: main.tAccent; radius: main.radiusSm }
							contentItem: Text { text: updateIdsBtn.text; color: main.tBg; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
							onClicked: { droidstar.update_dmr_ids(); updateDialog.open() }
						}
					}

					CheckBox { id: toggletx; height: 36; text: qsTr("Enable TX toggle mode"); onClicked: droidstar.set_toggletx(toggleTX.checked) }
					CheckBox { id: xrf2Ref; height: 36; text: qsTr("Use REF for XRF") }
					CheckBox { id: ipV6; height: 36; text: qsTr("Use IPv6 when available") }
				}
			}

			// === MMDVM MODEM CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: modemCol.height + main.sp4 * 2

				Column {
					id: modemCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "MMDVM MODEM"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					Row { width: parent.width; spacing: main.sp2
						Text { text: "RX Freq"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemRXFreqEdit; width: 100; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "TX Freq"; color: main.tTextMuted; font.pixelSize: 13; width: 60; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemTXFreqEdit; width: 100; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RX Offset"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemRXOffsetEdit; width: 80; height: 36; selectByMouse: true }
						Text { text: "TX Offset"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemTXOffsetEdit; width: 80; height: 36; selectByMouse: true }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RX Level"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemRXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "TX Level"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RX DC Off"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemRXDCOffsetEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "TX DC Off"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemTXDCOffsetEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "RF Level"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemRFLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "TX Delay"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemTXDelayEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "CWId TX"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemCWIdTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "DStar TX"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemDStarTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "DMR TX"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemDMRTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "YSF TX"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemYSFTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "P25 TX"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemP25TXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
						Text { text: "NXDN TX"; color: main.tTextMuted; font.pixelSize: 13; width: 70; verticalAlignment: Text.AlignVCenter; leftPadding: main.sp2 }
						TextField { id: _modemNXDNTXLevelEdit; width: 80; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
					Row { width: parent.width; spacing: main.sp2
						Text { text: "Baud"; color: main.tTextMuted; font.pixelSize: 13; width: 80; verticalAlignment: Text.AlignVCenter }
						TextField { id: _modemBaudEdit; width: 100; height: 36; selectByMouse: true; inputMethodHints: "ImhPreferNumbers" }
					}
				}
			}

			// === ADVANCED CARD ===
			Rectangle {
				width: parent.width - main.sp2 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius
				height: advCol.height + main.sp4 * 2

				Column {
					id: advCol
					width: parent.width - main.sp4 * 2
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "ADVANCED"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
					}

					CheckBox {
						id: _mmdvmBox
						height: 36
						text: qsTr("MMDVM_DIRECT")
						onClicked: droidstar.set_mmdvm_direct(_mmdvmBox.checked)
					}
					CheckBox {
						id: _debugBox
						height: 36
						text: qsTr("Debug output to stderr")
						onClicked: droidstar.set_debug(_debugBox.checked)
					}
				}
			}
		}
	}
}
