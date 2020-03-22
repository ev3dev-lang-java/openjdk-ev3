## Adding new major OpenJDK version

Upstream produces new OpenJDK releases in a half-year cadence.
The tip/master build (masqueraded as latest version) on Jenkins should
keep up with this, as master is always master.

To add a new released version, add an appropriate section in the
config.sh shell script. It's probably best to start by copying an older
release configuration and modifying it to match the new release configuration.

There is hopefully only one catch: the Host/Boot JDK provided should be
of the same or previous release (e.g. for building JDK13, it should be
JDK13 or JDK12). Usually AdoptOpenJDK builds are used for x86 builders
and our builds are used for ARM builders.

For setting up Jenkins builds, please see
[Integration with AdoptOpenJDK Jenkins](AdoptOpenJDK_Jenkins.md).
