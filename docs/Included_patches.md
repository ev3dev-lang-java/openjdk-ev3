## Included out-of-tree patches

In order to fix some issues in upstream OpenJDK, this repository
contains some out-of-tree patches.

### What we include

Note: JTreg included tests = tests bundled with the OpenJDK source tree.

#### OpenJDK 9

*is not present anymore*

#### OpenJDK 10

*is not present anymore*

#### OpenJDK 11
 * `jdk11.patch` - fixes runtime errors & adds cflags optimizations.
 * `jdk11_nosflt.patch` - removes the need for the external softfloat-3e library.
 * `jdk11_lib.patch` - adds Debian JNI library path to the build.
 * `jdk11_new.patch` - fixes bugs found on JDK12 by JTreg  incl. test on ARMv7.
 * `jdk11_bkpt.patch` - disables ARM-specific breakpoint instruction on VM errors.
 * `jdk11_cds.patch` - fixes crash (JTreg incl. test) caused by incorrect CDS data alignment.
 * `jdk11_jfr.patch` - fixes crash (JTreg incl. test) in the Java Flight Recorder file writer.

#### OpenJDK 12
 * `jdk12_nosflt.patch` - removes the need for the external softfloat-3e library.
 * `jdk12_new.patch` - fixes bugs found on JDK12 by JTreg incl. test on ARMv7.
 * `jdk12_bkpt.patch` - disables ARM-specific breakpoint instruction on VM errors.
 * `jdk12_cds.patch` - fixes crash (JTreg incl. test) caused by incorrect CDS data alignment.
 * `jdk12_jfr.patch` - fixes crash (JTreg incl. test) in Java Flight Recorder file writer.

#### OpenJDK 13
 * `jdk13_nosflt.patch` - removes the need for the external softfloat-3e library.
 * `jdk13_new.patch` - fixes bugs found on JDK12 by JTreg incl. test on ARMv7.
 * `jdk13_bkpt.patch` - disables ARM-specific breakpoint instruction on errors.
 * `jdk13_cds.patch` - fixes crash (JTreg incl. test) caused by incorrect CDS data alignment.
 * `jdk13_jfr.patch` - fixes crash (JTreg incl. test) in Java Flight Recorder file writer.

#### OpenJDK 14
 * `jdk14_nosflt.patch` - removes the need for the external softfloat-3e library.
 * `jdk14_new.patch` - fixes bugs found on JDK12 by JTreg incl. test on ARMv7.
 * `jdk14_bkpt.patch` - disables ARM-specific breakpoint instruction on errors.
 * `jdk14_cds.patch` - fixes crash (JTreg incl. test) caused by incorrect CDS data alignment.
 * `jdk14_jfr.patch` - fixes crash (JTreg incl. test) in Java Flight Recorder file writer.


### Patch rebasing
As the development continues in the OpenJDK upstream, is is necessary
to rebase the patches from time to time (or properly upstream them).
This can be done this way:

 1. Clone the JDK Git repositories on the correct tags:
    ```sh
    git clone --branch jdk-11.0.4-ga --depth 1 https://github.com/openjdk/jdk11u.git && cd jdk11u
    ```
 2. Apply the current patches one by one as individual commits, fixing the conflicts that arise.
    ```sh
    patch -p1 -i <patch1>
    rm <...>.orig
    git add <...>
    git commit -m “patch1”
    ```
 3. Print the commit log to get the hashes of the created commits.
    ```sh
    git log # or git hist, but you have to add an alias
    ```
 4. Re-export the patches by running the following command between individual commits:
    ```sh
    git diff <previoushash> <thishash>   > <patch1>
    ```

### Upstreaming
To upstream a patch (see also [OpenJDK guide][jdkguide]):
 1. Sign the Oracle Contributor Agreement and send it to Oracle.
 2. Create an issue in the JDK Bug System. (might be optional)
 3. Work on the patch.
 4. Send it to an appropriate mailing list and iterate on enhancing it until it's OK.

[jdkguide]: https://openjdk.java.net/contribute/
