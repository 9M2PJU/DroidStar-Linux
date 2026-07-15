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
import QtQuick.Window
import QtQuick.Controls

Item {
	id: mainTab
	property int rows: 18
	property bool tts: false

	onWidthChanged: updateLayout()
	onHeightChanged: updateLayout()

	function updateLayout() {
		var rowH = height / rows
		// Connection card
		_comboMode.x = main.sp2
		_comboMode.y = 0
		_comboMode.height = rowH
		_comboSlot.height = rowH
		_comboCC.height = rowH
		_connectbutton.height = rowH
		_comboHost.height = rowH
		_comboModule.height = rowH
		_privateBox.height = rowH

		if (_comboMode.currentText === "DMR") {
			_comboMode.width = width / 5 - main.sp1
			_comboSlot.x = width / 5
			_comboCC.x = width * 2 / 5
			_connectbutton.x = width * 3 / 5
			_connectbutton.width = width * 2 / 5 - main.sp2
		} else {
			_comboMode.width = width / 2 - main.sp2
			_connectbutton.x = width / 2
			_connectbutton.width = width / 2 - main.sp2
		}
		_comboHost.y = rowH + 1
		_comboHost.width = width * 3 / 4 - main.sp2
		_comboModule.x = width * 3 / 4
		_comboModule.y = rowH + 1
		_comboModule.width = width / 4 - main.sp2
		_privateBox.x = width * 3 / 4
		_privateBox.y = rowH + 1
		_privateBox.width = width / 4 - main.sp2

		// Font sizes
		var fs = Math.max(10, height / 40)
		_comboMode.font.pixelSize = fs
		_comboHost.font.pixelSize = fs
		_comboModule.font.pixelSize = fs
		_comboSlot.font.pixelSize = fs
		_comboCC.font.pixelSize = fs
		_connectbutton.font.pixelSize = Math.max(12, height / 30)
	}

	property alias element3: _element3
	property alias label1: _label1
	property alias label2: _label2
	property alias label3: _label3
	property alias label4: _label4
	property alias label5: _label5
	property alias label6: _label6
	property alias ambestatus: _ambestatus
	property alias mmdvmstatus: _mmdvmstatus
	property alias netstatus: _netstatus
	property alias levelMeter: _levelMeter
	property alias uitimer: _uitimer
	property alias comboMode: _comboMode
	property alias comboHost: _comboHost
	property alias dtmflabel: _dtmflabel
	property alias editIAXDTMF: _editIAXDTMF
	property alias dtmfsendbutton: _dtmfsendbutton
	property alias comboModule: _comboModule
	property alias comboSlot: _comboSlot
	property alias comboCC: _comboCC
	property alias dmrtgidEdit: _dmrtgidEdit
	property alias comboM17CAN: _comboM17CAN
	property alias privateBox: _privateBox
	property alias connectbutton: _connectbutton
	property alias sliderMicGain: _slidermicGain
	property alias data1: _data1
	property alias data2: _data2
	property alias data3: _data3
	property alias data4: _data4
	property alias data5: _data5
	property alias data6: _data6
	property alias txtimer: _txtimer
	property alias buttonTX: _buttonTX
	property alias btntxt: _btntxt
	property alias swtxBox: _swtxBox
	property alias swrxBox: _swrxBox
	property alias agcBox: _agcBox

	// Background
	Rectangle {
		anchors.fill: parent
		color: main.tBg
	}

	Timer {
		id: _uitimer
		interval: 20; running: true; repeat: true
		property int cnt: 0;
		property int rxcnt: 0;
		property int last_rxcnt: 0;
		onTriggered: update_level();

		function update_level(){
			if(cnt >= 20){
				if(rxcnt == last_rxcnt){
					droidstar.set_output_level(0);
					rxcnt = 0;
				}
				else{
					last_rxcnt = rxcnt;
				}
				cnt = 0;
			}
			else{
				++cnt;
			}
			var l = (mainTab.width - 20) * droidstar.get_output_level() / 32767.0;
			if(l > _levelMeter.width){
				_levelMeter.width = l;
			}
			else{
				if(_levelMeter.width > 0)
					_levelMeter.width -= 8;
				else
					_levelMeter.width = 0;
			}
		}
	}

	// === FIXED TOP: Connection Card ===
	Rectangle {
		id: connectionCard
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: mainTab.height / mainTab.rows * 2 + 4
		color: main.tSurface
		border.color: main.tBorder
		border.width: 1
		radius: main.radius

		ComboBox {
			id: _comboMode
			property bool loaded: false
			x: main.sp2
			y: 0
			width: mainTab.width / 2 - main.sp2
			height: mainTab.height / mainTab.rows
			font.pixelSize: Math.max(10, mainTab.height / 40)
			currentIndex: -1
			displayText: currentIndex === -1 ? "Mode..." : currentText
			model: ["M17", "YSF", "FCS", "DMR", "P25", "NXDN", "REF", "XRF", "DCS", "IAX"]
			contentItem: Text {
				text: _comboMode.displayText
				font: _comboMode.font
				leftPadding: 10
				verticalAlignment: Text.AlignVCenter
				color: _comboMode.enabled ? main.tText : main.tTextMuted
			}
			onCurrentTextChanged: {
				if(_comboMode.loaded){
					droidstar.process_mode_change(_comboMode.currentText);
				}
				updateLayout()
			}
		}

		ComboBox {
			id: _comboSlot
			x: mainTab.width / 5
			y: 0
			width: mainTab.width / 5
			height: mainTab.height / mainTab.rows
			font.pixelSize: Math.max(10, mainTab.height / 35)
			model: ["S1", "S2"]
			currentIndex: 1
			contentItem: Text {
				text: _comboSlot.displayText
				font: _comboSlot.font
				leftPadding: 10
				verticalAlignment: Text.AlignVCenter
				color: _comboSlot.enabled ? main.tText : main.tTextMuted
			}
			onCurrentIndexChanged: {
				droidstar.set_slot(_comboSlot.currentIndex);
			}
			visible: false
		}

		ComboBox {
			id: _comboCC
			x: mainTab.width * 2 / 5
			y: 0
			width: mainTab.width / 5
			height: mainTab.height / mainTab.rows
			font.pixelSize: Math.max(10, mainTab.height / 35)
			model: ["CC0", "CC1", "CC2", "CC3", "CC4", "CC5", "CC6", "CC7", "CC8", "CC9", "CC10", "CC11", "CC12", "CC13", "CC14", "CC15"]
			currentIndex: 1
			contentItem: Text {
				text: _comboCC.displayText
				font: _comboCC.font
				leftPadding: 10
				verticalAlignment: Text.AlignVCenter
				color: _comboCC.enabled ? main.tText : main.tTextMuted
			}
			onCurrentIndexChanged: {
				droidstar.set_cc(_comboCC.currentIndex);
			}
			visible: false
		}

		Button {
			id: _connectbutton
			x: mainTab.width / 2
			y: 0
			width: mainTab.width / 2 - main.sp2
			height: mainTab.height / mainTab.rows
			text: qsTr("Connect")
			font.pixelSize: Math.max(12, mainTab.height / 30)
			font.bold: true
			background: Rectangle {
				color: _connectbutton.text === "Disconnect" ? main.tDanger : main.tAccent
				radius: main.radiusSm
			}
			contentItem: Text {
				text: _connectbutton.text
				font: _connectbutton.font
				color: main.tBg
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}
			onClicked: {
				droidstar.set_callsign(settingsTab.callsignEdit.text.toUpperCase());
				droidstar.set_module(comboModule.currentText);
				droidstar.set_protocol(comboMode.currentText);
				droidstar.set_dmrtgid(dmrtgidEdit.text);
				droidstar.set_dmrid(settingsTab.dmridEdit.text);
				droidstar.set_essid(settingsTab.comboEssid.currentText);
				droidstar.set_bm_password(settingsTab.bmpwEdit.text);
				droidstar.set_tgif_password(settingsTab.tgifpwEdit.text);
				droidstar.set_asl_password(settingsTab.aslpwEdit.text);
				droidstar.set_latitude(settingsTab.latEdit.text);
				droidstar.set_longitude(settingsTab.lonEdit.text);
				droidstar.set_location(settingsTab.locEdit.text);
				droidstar.set_description(settingsTab.descEdit.text);
				droidstar.set_url(settingsTab.urlEdit.text);
				droidstar.set_swid(settingsTab.swidEdit.text);
				droidstar.set_pkgid(settingsTab.pkgidEdit.text);
				droidstar.set_dmr_options(settingsTab.dmroptsEdit.text);
				droidstar.set_dmr_pc(mainTab.privateBox.checked);
				droidstar.set_txtimeout(settingsTab.txtimerEdit.text);
				droidstar.set_xrf2ref(settingsTab.xrf2ref.checked);
				droidstar.set_ipv6(settingsTab.ipv6.checked);
				droidstar.set_vocoder(settingsTab.comboVocoder.currentText);
				droidstar.set_modem(settingsTab.comboModem.currentText);
				droidstar.set_playback(settingsTab.comboPlayback.currentText);
				droidstar.set_capture(settingsTab.comboCapture.currentText);
				droidstar.set_modemRxFreq(settingsTab.modemRXFreqEdit.text);
				droidstar.set_modemTxFreq(settingsTab.modemTXFreqEdit.text);
				droidstar.set_modemRxOffset(settingsTab.modemRXOffsetEdit.text);
				droidstar.set_modemTxOffset(settingsTab.modemTXOffsetEdit.text);
				droidstar.set_modemRxDCOffset(settingsTab.modemRXDCOffsetEdit.text);
				droidstar.set_modemTxDCOffset(settingsTab.modemTXDCOffsetEdit.text);
				droidstar.set_modemRxLevel(settingsTab.modemRXLevelEdit.text);
				droidstar.set_modemTxLevel(settingsTab.modemRXLevelEdit.text);
				droidstar.set_modemRFLevel(settingsTab.modemRFLevelEdit.text);
				droidstar.set_modemTxDelay(settingsTab.modemTXDelayEdit.text);
				droidstar.set_modemCWIdTxLevel(settingsTab.modemCWIdTXLevelEdit.text);
				droidstar.set_modemDstarTxLevel(settingsTab.modemDStarTXLevelEdit.text);
				droidstar.set_modemDMRTxLevel(settingsTab.modemDMRTXLevelEdit.text);
				droidstar.set_modemYSFTxLevel(settingsTab.modemYSFTXLevelEdit.text);
				droidstar.set_modemP25TxLevel(settingsTab.modemYSFTXLevelEdit.text);
				droidstar.set_modemNXDNTxLevel(settingsTab.modemNXDNTXLevelEdit.text);
				droidstar.set_modemBaud(settingsTab.modemBaudEdit.text);
				droidstar.process_connect();
			}
		}

		ComboBox {
			id: _comboHost
			x: main.sp2
			y: mainTab.height / mainTab.rows + 1
			width: mainTab.width * 3 / 4 - main.sp2
			height: mainTab.height / mainTab.rows
			font.pixelSize: Math.max(10, mainTab.height / 35)
			currentIndex: -1
			displayText: currentIndex === -1 ? "Host..." : currentText
			contentItem: Text {
				text: _comboHost.displayText
				font: _comboHost.font
				leftPadding: 10
				verticalAlignment: Text.AlignVCenter
				color: _comboHost.enabled ? main.tText : main.tTextMuted
			}
			onCurrentTextChanged: {
				if(settingsTab.mmdvmBox.checked){
					droidstar.set_dst(_comboHost.currentText);
				}
				if(!droidstar.get_modelchange()){
					droidstar.process_host_change(_comboHost.currentText);
				}
			}
		}

		ComboBox {
			id: _comboModule
			x: mainTab.width * 3 / 4
			y: mainTab.height / mainTab.rows + 1
			width: mainTab.width / 4 - main.sp2
			height: mainTab.height / mainTab.rows
			font.pixelSize: Math.max(10, mainTab.height / 35)
			currentIndex: -1
			displayText: currentIndex === -1 ? "Mod..." : currentText
			model: [" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
			contentItem: Text {
				text: _comboModule.displayText
				font: _comboModule.font
				leftPadding: 10
				verticalAlignment: Text.AlignVCenter
				color: _comboModule.enabled ? main.tText : main.tTextMuted
			}
			onCurrentTextChanged: {
				if(_comboMode.loaded){
					droidstar.set_module(_comboModule.currentText);
				}
			}
		}

		CheckBox {
			id: _privateBox
			x: mainTab.width * 3 / 4
			y: mainTab.height / mainTab.rows + 1
			width: mainTab.width / 4 - main.sp2
			height: mainTab.height / mainTab.rows
			text: qsTr("Private")
			font.pixelSize: Math.max(9, mainTab.height / 45)
			onClicked: {
				droidstar.set_dmr_pc(privateBox.checked)
			}
			visible: false
		}
	}

	// === SCROLLABLE MIDDLE SECTION ===
	Flickable {
		id: scrollArea
		anchors.top: connectionCard.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: pttContainer.top
		anchors.topMargin: main.sp1
		anchors.bottomMargin: main.sp1
		clip: true
		contentHeight: scrollContent.height
		boundsBehavior: Flickable.StopAtBounds

		Column {
			id: scrollContent
			width: parent.width
			spacing: main.sp1

			// --- Audio Card ---
			Rectangle {
				width: parent.width - main.sp2 * 2
				height: audioCol.height + main.sp4 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius

				Column {
					id: audioCol
					width: parent.width - main.sp4
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					// Section header
					Text {
						text: "AUDIO"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
						leftPadding: main.sp1
					}

					// Row: TGID/CAN + M17CAN + checkboxes
					Row {
						width: parent.width
						spacing: main.sp1

						Text {
							id: _element3
							width: parent.width / 5
							height: mainTab.height / mainTab.rows
							text: qsTr("TGID")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 40)
							verticalAlignment: Text.AlignVCenter
							visible: false
						}
						TextField {
							id: _dmrtgidEdit
							width: parent.width / 5
							height: mainTab.height / mainTab.rows
							font.pixelSize: Math.max(10, mainTab.height / 35)
							selectByMouse: true
							inputMethodHints: "ImhPreferNumbers"
							text: qsTr("")
							visible: false
							onEditingFinished: {
								droidstar.tgid_text_changed(dmrtgidEdit.text)
							}
						}
						ComboBox {
							id: _comboM17CAN
							width: parent.width / 5
							height: mainTab.height / mainTab.rows
							font.pixelSize: Math.max(10, mainTab.height / 35)
							currentIndex: 0
							model: ["0", "1", "2", "3", "4", "5", "6", "7"]
							visible: false
							contentItem: Text {
								text: _comboM17CAN.displayText
								font: _comboM17CAN.font
								leftPadding: 10
								verticalAlignment: Text.AlignVCenter
								color: _comboM17CAN.enabled ? main.tText : main.tTextMuted
							}
							onCurrentTextChanged: {
								droidstar.set_modemM17CAN(_comboM17CAN.currentText);
							}
						}
						CheckBox {
							id: _swtxBox
							width: parent.width / 4
							height: mainTab.height / mainTab.rows
							font.pixelSize: Math.max(9, mainTab.height / 45)
							text: qsTr("SWTX")
							onClicked: {
								droidstar.set_swtx(_swtxBox.checked)
							}
						}
						CheckBox {
							id: _swrxBox
							width: parent.width / 4
							height: mainTab.height / mainTab.rows
							font.pixelSize: Math.max(9, mainTab.height / 45)
							text: qsTr("SWRX")
							onClicked: {
								droidstar.set_swrx(_swrxBox.checked)
							}
						}
					}

					// Row: AGC + Mic slider
					Row {
						width: parent.width
						spacing: main.sp1

						CheckBox {
							id: _agcBox
							width: parent.width / 4
							height: mainTab.height / mainTab.rows
							font.pixelSize: Math.max(9, mainTab.height / 45)
							text: qsTr("AGC")
							onClicked: {
								droidstar.set_agc(_agcBox.checked)
							}
						}
						Text {
							id: micgain_label
							width: parent.width / 3
							height: mainTab.height / mainTab.rows
							text: "Mic " + (_slidermicGain.value * 100).toFixed(1) + "%"
							color: main.tText
							font.pixelSize: Math.max(9, mainTab.height / 45)
							verticalAlignment: Text.AlignVCenter
						}
						Slider {
							id: _slidermicGain
							width: parent.width - parent.width / 4 - parent.width / 3 - main.sp2
							height: mainTab.height / mainTab.rows
							value: 0.5
							onValueChanged: {
								droidstar.set_input_volume(value);
							}
						}
					}

					// DTMF row (IAX only)
					Row {
						width: parent.width
						spacing: main.sp1
						height: _dtmflabel.visible ? mainTab.height / mainTab.rows : 0

						Text {
							id: _dtmflabel
							width: parent.width / 5
							height: parent.height
							text: qsTr("DTMF")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 40)
							verticalAlignment: Text.AlignVCenter
							visible: false
						}
						TextField {
							id: _editIAXDTMF
							width: parent.width * 3 / 8
							height: parent.height
							font.pixelSize: Math.max(10, mainTab.height / 35)
							visible: false
						}
						Button {
							id: _dtmfsendbutton
							width: parent.width * 3 / 8 - main.sp2
							height: parent.height
							text: qsTr("Send")
							font.pixelSize: Math.max(10, mainTab.height / 35)
							visible: false
							onClicked: {
								droidstar.dtmf_send_clicked(editIAXDTMF.text);
							}
						}
					}
				}
			}

			// --- Status Data Card ---
			Rectangle {
				width: parent.width - main.sp2 * 2
				height: statusCol.height + main.sp4 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius

				Column {
					id: statusCol
					width: parent.width - main.sp4
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: 2

					Text {
						text: "STATUS"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
						leftPadding: main.sp1
						bottomPadding: main.sp1
					}

					Row {
						width: parent.width
						Text {
							id: _label1
							width: parent.width / 3
							text: qsTr("MYCALL")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data1
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
					Row {
						width: parent.width
						Text {
							id: _label2
							width: parent.width / 3
							text: qsTr("URCALL")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data2
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
					Row {
						width: parent.width
						Text {
							id: _label3
							width: parent.width / 3
							text: qsTr("RPTR1")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data3
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
					Row {
						width: parent.width
						Text {
							id: _label4
							width: parent.width / 3
							text: qsTr("RPTR2")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data4
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
					Row {
						width: parent.width
						Text {
							id: _label5
							width: parent.width / 3
							text: qsTr("StrmID")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data5
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
					Row {
						width: parent.width
						Text {
							id: _label6
							width: parent.width / 3
							text: qsTr("Text")
							color: main.tTextMuted
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
						Text {
							id: _data6
							width: parent.width * 2 / 3
							text: qsTr("")
							color: main.tText
							font.pixelSize: Math.max(10, mainTab.height / 45)
						}
					}
				}
			}

			// --- Hardware Status Card ---
			Rectangle {
				width: parent.width - main.sp2 * 2
				height: hwCol.height + main.sp4 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius

				Column {
					id: hwCol
					width: parent.width - main.sp4
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "HARDWARE"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
						leftPadding: main.sp1
					}

					Text {
						id: _ambestatus
						width: parent.width
						text: qsTr("No AMBE hardware connected")
						color: main.tTextMuted
						font.pixelSize: Math.max(9, mainTab.height / 50)
						wrapMode: Text.Wrap
					}
					Text {
						id: _mmdvmstatus
						width: parent.width
						text: qsTr("No MMDVM connected")
						color: main.tTextMuted
						font.pixelSize: Math.max(9, mainTab.height / 50)
						wrapMode: Text.Wrap
					}
					Text {
						id: _netstatus
						width: parent.width
						text: qsTr("Not connected")
						color: main.tTextMuted
						font.pixelSize: Math.max(9, mainTab.height / 50)
						wrapMode: Text.Wrap
					}

					// Level meter
					Text {
						text: "Audio Level"
						color: main.tTextMuted
						font.pixelSize: 11
						leftPadding: main.sp1
					}
					Rectangle {
						width: parent.width
						height: 16
						color: main.tBg
						radius: 4
						border.color: main.tBorder
						border.width: 1
						clip: true
						Rectangle {
							id: _levelMeter
							width: 0
							height: parent.height
							color: main.tAccent
							radius: 4
						}
					}
				}
			}

			// TTS controls (if enabled)
			Rectangle {
				visible: mainTab.tts
				width: parent.width - main.sp2 * 2
				height: ttsCol.height + main.sp4 * 2
				anchors.horizontalCenter: parent.horizontalCenter
				color: main.tSurface
				border.color: main.tBorder
				border.width: 1
				radius: main.radius

				Column {
					id: ttsCol
					width: parent.width - main.sp4
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: parent.top
					anchors.topMargin: main.sp4
					spacing: main.sp2

					Text {
						text: "TTS"
						color: main.tAccent
						font.pixelSize: 11
						font.bold: true
				font.letterSpacing: 1
						leftPadding: main.sp1
					}

					ButtonGroup {
						id: ttsvoicegroup
						onClicked: {
							droidstar.tts_changed(button.text);
						}
					}

					Row {
						width: parent.width
						spacing: main.sp1
						CheckBox {
							id: mic
							height: 25
							spacing: 1
							text: qsTr("Mic")
							checked: true
							ButtonGroup.group: ttsvoicegroup
						}
						CheckBox {
							id: tts1
							height: 25
							spacing: 1
							text: qsTr("TTS1")
							ButtonGroup.group: ttsvoicegroup
						}
						CheckBox {
							id: tts2
							height: 25
							spacing: 1
							text: qsTr("TTS2")
							checked: true
							ButtonGroup.group: ttsvoicegroup
						}
						CheckBox {
							id: tts3
							height: 25
							spacing: 1
							text: qsTr("TTS3")
							ButtonGroup.group: ttsvoicegroup
						}
					}

					TextField {
						id: _ttstxtedit
						width: parent.width
						font.pixelSize: Math.max(10, mainTab.height / 35)
						selectByMouse: true
						inputMethodHints: "ImhPreferNumbers"
						text: qsTr("")
						onEditingFinished: {
							droidstar.tts_text_changed(_ttstxtedit.text)
						}
					}
				}
			}
		}
	}

	// === FIXED BOTTOM: PTT Button ===
	Item {
		id: pttContainer
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: Math.max(80, mainTab.height * 0.18)

		Button {
			id: _buttonTX
			property bool tx: false
			property int cnt: 0
			visible: true
			enabled: false
			anchors.fill: parent
			anchors.margins: main.sp2
			opacity: enabled ? 1.0 : 0.7
			topPadding: 0
			bottomPadding: 0
			leftPadding: 0
			rightPadding: 0

			Timer {
				id: _txtimer
				repeat: true;
				onTriggered: {
					++buttonTX.cnt;
					btntxt.text = "TX: " + buttonTX.cnt;
					if(buttonTX.cnt >= parseInt(settingsTab.txtimerEdit.text)){
						buttonTX.tx = false;
						droidstar.click_tx(buttonTX.tx);
						_txtimer.running = false;
						_btntxt.text = "PTT";
					}
				}
			}

			background: Rectangle {
				color: _buttonTX.tx ? "#8b0000" : main.tAccent
				radius: 24
				border.color: main.tBorder
				border.width: 1
				anchors.fill: parent

				Text {
					id: _btntxt
					anchors.centerIn: parent
					font.pixelSize: Math.min(parent.width / 8, parent.height / 4)
					font.bold: true
					font.letterSpacing: 2
					text: qsTr("PTT")
					color: _buttonTX.tx ? "#ff4444" : main.tBg
					style: Text.Outline
					styleColor: main.tAccent
				}
			}

			onClicked: {
				if(settingsTab.toggleTX.checked){
					tx = !tx;
					droidstar.click_tx(tx);
					if(tx){
						cnt = 0;
						_txtimer.running = true;
						_btntxt.color = "#ff4444";
					}
					else{
						_txtimer.running = false;
						btntxt.color = main.tBg;
						_btntxt.text = "PTT";
					}
				}
			}
			onPressed: {
				if(!settingsTab.toggleTX.checked){
					tx = true;
					droidstar.press_tx();
				}
			}
			onReleased: {
				if(!settingsTab.toggleTX.checked){
					tx = false;
					droidstar.release_tx();
				}
			}
			onCanceled: {
				if(!settingsTab.toggleTX.checked){
					tx = false;
					droidstar.release_tx();
				}
			}
		}
	}
}
