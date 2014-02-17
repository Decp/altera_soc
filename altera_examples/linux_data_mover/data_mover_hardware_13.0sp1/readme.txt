This hardware example design was branched off of the Cyclone V SoC GHRD
example from the 13.0sp1 tools release which is typically installed along this
path:

/tools/soceds/13.0sp1/232/linux32/examples/hardware/cv_soc_devkit_ghrd

Much of the GHRD project infrastructure was kept in place and the specific
requirements for this example were added to it.  Most of the stale pieces of
the GHRD that were not required by this example should have been removed,
though there may be a few stale remnants.

To build this example, run the provided build script:

./build_hardware.sh

