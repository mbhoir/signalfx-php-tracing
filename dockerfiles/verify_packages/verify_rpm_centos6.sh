#!/bin/sh

set -e

if [ -z "${PHP_INSTALL_DIR}" ]; then
    echo "Please set PHP_INSTALL_DIR"
    exit 1
fi

for phpVer in $(ls ${PHP_INSTALL_DIR}); do
    echo "Installing signalfx-php-tracing on PHP ${phpVer}..."
    switch-php $phpVer

    # Installing signalfx-php-tracing
    INSTALL_TYPE="${INSTALL_TYPE:-php_installer}"
    if [ "$INSTALL_TYPE" = "native_package" ]; then
        echo "Installing dd-trace-php using the OS-specific package installer"
        rpm -Uvh build/packages/*.rpm
        php --ri=signalfx_tracing

        # Uninstall the tracer
        rpm -e signalfx_tracing
        rm -f /opt/signalfx_php_tracing/etc/ddtrace.ini
    else
        echo "Installing signalfx-php-tracing using the new PHP installer"
        installable_bundle=$(find "build/packages" -maxdepth 1 -name 'dd-library-php-*-x86_64-linux-gnu.tar.gz')
        php datadog-setup.php --file "$installable_bundle" --php-bin all
    fi
done
