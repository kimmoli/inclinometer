
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
        active: Qt.ApplicationActive

        property double angle: 0.0
        property double x: 0.0
        property double y: 0.0

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

            angle = a * (180/Math.PI)
        }
    }

    SoundEffect
    {
        id: tick
        source: angleLabel.text == "90.0" ? "/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav" :
                        "/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav"
    }

    Label
    {
        id: angleLabel
        anchors.centerIn: parent
        rotation: accelerometer.angle
        text: accelerometer.angle.toFixed(1)
        font.pixelSize: Math.min(parent.height, parent.width) / 3
        font.bold: true
    }

    Timer
    {
        id: tickTimer
        interval: 600
        running: ((accelerometer.angle > 85.0) && (accelerometer.angle < 95.0))
        repeat: true
        onTriggered:
        {
            tick.play()
            interval = 100.0 * Math.abs(90.0 - accelerometer.angle) + 50.0
        }
    }
}


