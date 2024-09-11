# BSIM Demo

This repo showcases how you can use Babblesim to develop Bluetooth applications.

There are two demos:

## GATT bug

In this demo, we are developing a Bluetooth device that uses the central role.

It connects to a peripheral device, and does a GATT service discovery, trying to
subscribe to the heart-rate measurement characteristic.

However, there is a bug in the discovery. Using Babblesim, we can find it (hint
it's in the commit history) much quicker than if we had to flash and debug on a
real device.

We can observe discovery parameters at our leisure in any of the discovery
iterations, and still have the Bluetooth link running. All the simulated
peripherals also stop when we hit a breakpoint. This is pretty much impossible
on hardware.

### Using the demo

- Install VSCode + the devcontainer extension
- Open this repo in VSCode, click "open in container" when the pop-up appears
- Click "Terminal" -> "Run Build Task"
- Click "Run" -> "Start debugging"
- Use the debugger to step through code

## Python demo

This demo showcases that you can also use Babblesim to develop Bluetooth
applications using a different language or runtime than Zephyr.

In this demo, we have a very minimal Bluetooth "host" written in Python. It
communicates with a Bluetooth controller that is in a simulation with a scanning
device.

```
[host] <-- virtual UART (fifo) --> [controller] <-- Simulated RF (bsim) --> [scanner (controller + host)]
```

Both the controller and the scanner are built using Zephyr.

The python application doesn't talk to Babblesim, and does not need to use the
Zephyr API at all.

This setup enables a faster feedback loop during development and you get full RF
traffic immediately, without expensive equipment.

### Using the demo

- Open a terminal in `python-demo/` and run `run.sh`
- Open another terminal in `python-demo/` and run `python ble-host.py`
- The scanning device logs Bluetooth advertising reports
- Stop the simulation using Ctrl-C

The packet trace will be exported to `python-demo/trace.pcap` and you can open
it in Wireshark.
