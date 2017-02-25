
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0
import QtMultimedia 5.0

Page
{
    id: page

    anchors.fill: parent

    Accelerometer
    {
        id: accelerometer
        dataRate: 25
        active: Qt.application.state === Qt.ApplicationActive

        property double delta: 0.0
        property double rawAngle: 0.0
        property double angle: 0.0
        property double x: 0.0
        property double y: 0.0
        property double z: 0.0

        Behavior on x { NumberAnimation { duration: 175 } }
        Behavior on y { NumberAnimation { duration: 175 } }

        onReadingChanged:
        {
            x = reading.x
            y = reading.y

            var a

            if ( (Math.atan(y / Math.sqrt(y * y + x * x))) >= 0 )
                a = -(Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )
            else
                a = Math.PI + (Math.acos(x / Math.sqrt(y * y + x * x)) - (Math.PI/2) )

            rawAngle = a * (180/Math.PI)
            angle = rawAngle + delta
        }
    }

    MouseArea
    {
        id: bg
        anchors.fill: parent
        onPressAndHold: accelerometer.delta = 90.0 - accelerometer.rawAngle
        onDoubleClicked: accelerometer.delta = 0.0
    }

    Label
    {
        id: angleLabel
        anchors.centerIn: parent
        rotation: accelerometer.rawAngle
        text: accelerometer.angle.toFixed(1)
        font.pixelSize: Math.min(parent.height, parent.width) / 3
        font.bold: true
        color: bg.pressed ? Theme.highlightColor : Theme.primaryColor

        Rectangle
        {
            id: line
            anchors.centerIn: parent
            color: bg.pressed ? Theme.highlightColor : Theme.secondaryColor
            opacity: 0.3
            height: 10
            width: parent.paintedWidth
        }
        Rectangle
        {
            id: lineRight
            anchors.verticalCenter: line.verticalCenter
            anchors.left: line.right
            color: line.color
            height: line.height
            width: Math.max(page.height, page.width)/2
        }
        Rectangle
        {
            id: lineLeft
            anchors.verticalCenter: line.verticalCenter
            anchors.right: line.left
            color: line.color
            height: line.height
            width: Math.max(page.height, page.width)/2
        }
        OpacityRampEffect
        {
            sourceItem: lineLeft
            direction: OpacityRamp.LeftToRight
            offset: 0.65
        }
        OpacityRampEffect
        {
            sourceItem: lineRight
            direction: OpacityRamp.RightToLeft
            offset: 0.65
        }
    }

    Item
    {
        id: calibItem
        anchors.centerIn: angleLabel
        rotation: 90 - accelerometer.delta;
        z: -1

        Rectangle
        {
            id: calibLine
            anchors.centerIn: parent
            color: Theme.secondaryHighlightColor
            opacity: 0.3
            height: 5
            width: angleLabel.paintedWidth
        }
        Rectangle
        {
            id: calibLineRight
            anchors.verticalCenter: calibLine.verticalCenter
            anchors.left: calibLine.right
            color: calibLine.color
            height: calibLine.height
            width: Math.max(page.height, page.width)/2
        }
        Rectangle
        {
            id: calibLineLeft
            anchors.verticalCenter: calibLine.verticalCenter
            anchors.right: calibLine.left
            color: calibLine.color
            height: calibLine.height
            width: Math.max(page.height, page.width)/2
        }
        OpacityRampEffect
        {
            sourceItem: calibLineLeft
            direction: OpacityRamp.LeftToRight
            offset: 0.65
        }
        OpacityRampEffect
        {
            sourceItem: calibLineRight
            direction: OpacityRamp.RightToLeft
            offset: 0.65
        }
    }

    Timer
    {
        id: tickTimer
        interval: 600
        running: ((accelerometer.angle > 85.0) && (accelerometer.angle < 95.0)) && (Qt.application.state === Qt.ApplicationActive)
        triggeredOnStart: true
        repeat: true
        onTriggered:
        {
            tick.play()
            interval = 100.0 * Math.abs(90.0 - accelerometer.angle) + 50.0
        }
    }

    SoundEffect
    {
        id: tick
        source: angleLabel.text == "90.0" ? "/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav" :
                        "/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav"
    }
}


