# Extension ID for the Pendo Launcher - this is the same for everyone, and
# can be found in the chrome web store listing of the extension
# https://chrome.google.com/webstore/detail/pendo-launcher/epnhoepnmfjdbjjfanpjklemanhkjgil
$CHROME_WEB_STORE_EXTENSION_ID = 'epnhoepnmfjdbjjfanpjklemanhkjgil'
$CHROME_WEB_STORE_UPDATE_URL = 'https://clients2.google.com/service/update2/crx'
$EXTENSION_INSTALL_FORCE_LIST_STRING = "$CHROME_WEB_STORE_EXTENSION_ID;$CHROME_WEB_STORE_UPDATE_URL"

$CHROME_REGISTRY_BASE = 'Registry::HKEY_CURRENT_USER\Software\Policies\Google\Chrome'
$CHROME_REGISTRY_FORCE_LIST = "$CHROME_REGISTRY_BASE\ExtensionInstallForcelist"
$CHROME_REGISTRY_EXT_CONFIG = "$CHROME_REGISTRY_BASE\3rdparty\extensions\$CHROME_WEB_STORE_EXTENSION_ID\policy"

# Chrome stores extension force lists under ExtensionInstallForcelist
# In the windows registry, this is a registry key that can contain many properties that refer
# to different force-installed extensions
# Pendo specifically uses the number 1000 to ensure we don't overwrite any existing
# configuration around force installed extensions - this number is arbitrary and can be changed as needed
$PENDO_FORCE_LIST_EXTENSION_NAME = 1000

$forceListExists = Test-Path $CHROME_REGISTRY_FORCE_LIST
if(-Not $forceListExists) {
    New-Item -Path $CHROME_REGISTRY_FORCE_LIST -Force
}

# Add a registry key that tells chrome to force an installation of the Pendo Launcher
Set-ItemProperty $CHROME_REGISTRY_FORCE_LIST -Name $PENDO_FORCE_LIST_EXTENSION_NAME -Value $EXTENSION_INSTALL_FORCE_LIST_STRING

$configExists = Test-Path $CHROME_REGISTRY_EXT_CONFIG
if(-Not $configExists) {
    New-Item -Path $CHROME_REGISTRY_EXT_CONFIG -Force
}

# Your subscription's Extension API Key. This is specific to each customer
$apiKey = 'c42f9767-6980-4fed-7a3c-4131158b519a'
Set-ItemProperty $CHROME_REGISTRY_EXT_CONFIG -Name APIKey -Value $apiKey

# The below section used to collect and assign employee-specific metadata, such as email address
# If this section is not filled in, the Pendo Launcher will set the "visitorId" of an employee
# to the email address of the logged in chrome user

# Example of building a JSON string for configuring an employee's metadata
$user = $env:USERNAME
$visitorId = "$user"
$visitorJson= "{ `"id`": `"$($visitorId)`" }"
Set-ItemProperty $CHROME_REGISTRY_EXT_CONFIG -Name visitor -Value $visitorJson -Type ExpandString