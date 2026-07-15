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

Item {
	id: aboutTab
	Rectangle{
		id: helpText
		x: 20
		y: 20
		width: parent.width - 40
		height: parent.height - 40
		color: "#252424"
		Flickable{
			anchors.fill: parent
			contentWidth: parent.width
			contentHeight: aboutText.y + aboutText.height
			flickableDirection: Flickable.VerticalFlick
			clip: true
			Text {
				id: aboutText
				width: helpText.width
				wrapMode: Text.WordWrap
				color: "white"
				text: qsTr(	"\nDroidStar-9M2PJU git build " + droidstar.get_software_build() +
						   "\nPlatform:\t" + droidstar.get_platform() +
						   "\nArchitecture:\t" + droidstar.get_arch() +
						   "\nBuild ABI:\t" + droidstar.get_build_abi() +
						   "\n\n9M2PJU Linux build (amd64/arm64) - .deb / .rpm / .AppImage" +
						   "\nPackaged for Linux by 9M2PJU. All credit for the original" +
						   "\nDroidStar software goes to its author, Doug McLain AD8DP." +
						   "\nThis is an unofficial Linux packaging of the upstream project." +
						   "\n\nOriginal project page: https://github.com/nostar/DroidStar" +
						   "\n\nCopyright (C) 2019-2026 Doug McLain AD8DP\n" +
							"This program is free software; " +
							"you can redistribute it and/or modify it under the terms of the GNU General " +
							"Public License as published by the Free Software Foundation; version 2.\n\n" +
							"This program is distributed in the hope that it will be useful, but WITHOUT " +
							"ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS " +
							"FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\n" +
							"You should have received a copy of the GNU General Public License along with this " +
							"program. If not, see <http://www.gnu.org/licenses/>")
			}
		}
	}
}
