## Ideas about testing the builds

There isn't much testing done. However, there are some ideas about
what could be implemented in the future:

 * Run JTreg tests in QEMU.
   - This hits the problem that QEMU is an emulator, not a simulator -
     to catch everything, it would have to simulate everything (and
     work fully with Hotspot JIT, which wasn't always the case).
   - This was once implemented, but it hasn't been maintained.
 * Run JTreg tests on ARMv8 capable of running 32bit binaries.
   - This hasn't been done yet, but it could yield some results.
     However, this depends on that the AArch32 ABI will produce
     the same effects as the ARMv5TEJ ABI of the ARM926EJ-S in the EV3.
   - **This has some potential.** AdoptOpenJDK has ARMv8 32bit servers,
     but I'm not sure there's any that is targetted for testing workloads.
 * Run JTreg tests on ARMv7.
   - This has been done and it has catched some regressions with
     OpenJDK's bundled test suite. However, it hasn't been automated.
     It depends also on the behaviour on ARMv5 not being different from ARMv7.
   - **This has some potential.** AdoptOpenJDK has ARMv7 test build servers.
 * Run bootcycle-builds on ARMv8 or ARMv7.
   - This is currently implemented. When the native build model is
     selected, the OpenJDK build is actually performed twice - first
     with the Host JDK and then with the newly built JDK. This makes
     sure that at least basic functionality is present; however once
     again, the behaviour might be different.
 * Run JTreg tests on the EV3.
   - This isn't possible due to the small amount of RAM on the EV3
     (64 MB). The system will basically swap to death.
 * Run JTreg tests split on the EV3 and on the PC.
   - This alleviated a little of the memory pressure by building
     the tests on a powerful computer, only running them on the EV3.
   - This also hasn't worked; it was still very slow and I think it
     eventually died due to swapping.
 * Run JTreg tests on some ARMv5 board with more memory.
   - This hasn't been implemented and it might fail too.
     There are some boards with 128 MB of RAM, which is however
     still quite little.
 * Run Oracle TCK <somewhere>.
   - This hasn't been implemented, as the TCK is not public.
     However this would provide a very wide test coverage and
     it would make sure that we can officially call this thing a JVM.
