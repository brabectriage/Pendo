# Extension ID for the Pendo Launcher - this is the same for everyone, and
# can be found in the edge web store listing of the extension
# https://microsoftedge.microsoft.com/addons/detail/pendo-launcher/lgpofjmgggolmabddgdmbgipcnblpnbm
$EDGE_WEB_STORE_EXTENSION_ID = 'lgpofjmgggolmabddgdmbgipcnblpnbm'
$EDGE_WEB_STORE_UPDATE_URL = 'https://edge.microsoft.com/extensionwebstorebase/v1/crx'
$EXTENSION_INSTALL_FORCE_LIST_STRING = "$EDGE_WEB_STORE_EXTENSION_ID;$EDGE_WEB_STORE_UPDATE_URL"

$EDGE_REGISTRY_BASE = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge'
$EDGE_REGISTRY_FORCE_LIST = "$EDGE_REGISTRY_BASE\ExtensionInstallForcelist"
$EDGE_REGISTRY_EXT_CONFIG = "$EDGE_REGISTRY_BASE\3rdparty\extensions\$EDGE_WEB_STORE_EXTENSION_ID\policy"

# Edge stores extension force lists under ExtensionInstallForcelist
# In the windows registry, this is a registry key that can contain many properties that refer
# to different force-installed extensions
# Pendo specifically uses the number 1000 to ensure we don't overwrite any existing
# configuration around force installed extensions - this number is arbitrary and can be changed as needed
$PENDO_FORCE_LIST_EXTENSION_NAME = 1000

$forceListExists = Test-Path $EDGE_REGISTRY_FORCE_LIST
if(-Not $forceListExists) {
    New-Item -Path $EDGE_REGISTRY_FORCE_LIST -Force
}

# Add a registry key that tells edge to force an installation of the Pendo Launcher
Set-ItemProperty $EDGE_REGISTRY_FORCE_LIST -Name $PENDO_FORCE_LIST_EXTENSION_NAME -Value $EXTENSION_INSTALL_FORCE_LIST_STRING

$configExists = Test-Path $EDGE_REGISTRY_EXT_CONFIG
if(-Not $configExists) {
    New-Item -Path $EDGE_REGISTRY_EXT_CONFIG -Force
}

# Your subscription's Extension API Key. This is specific to each customer
$apiKey = 'c42f9767-6980-4fed-7a3c-4131158b519a'
Set-ItemProperty $EDGE_REGISTRY_EXT_CONFIG -Name APIKey -Value $apiKey

# The below section used to collect and assign employee-specific metadata, such as email address
# If this section is not filled in, the Pendo Launcher will set the "visitorId" of an employee
# to the email address of the logged in edge user

# Example of building a JSON string for configuring an employee's metadata
$user = $env:USERNAME
$visitorId = "$user"
$visitorJson= "{ `"id`": `"$($visitorId)`" }"
Set-ItemProperty $EDGE_REGISTRY_EXT_CONFIG -Name visitor -Value $visitorJson -Type ExpandString