#Verificar o caminho no registro se é o mesmo de uma versão para a outra.
#Verificar com a squad se é necessário a desinstalação da versão anterior do Java.
#Verificar com a squad se caso o Java não esteja instalado na maquina, se é necessário fazer a instalação.

# Verifica a versao do Java instalado
$java_version = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\"Java Runtime Environment"\ -ErrorAction SilentlyContinue).CurrentVersion
$c_tmp = "$env:windir\Temp"
$java_installer_path = "$c_tmp\java.exe" 
$java_download_url = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=247947_0ae14417abb444ebb02b9815e2103550"

# Fazendo o download e instalação do Java
if (!$java_version) {
    Write-Host "Java nao esta instalado"
    Write-Host "Iniciando download e instalação do Java"
    Invoke-WebRequest -Uri $java_download_url -OutFile $java_installer_path

    Start-Process -FilePath $java_installer_path -ArgumentList "/s" -Wait
    $latest_version = (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\"Java Runtime Environment"\ -ErrorAction SilentlyContinue).CurrentVersion
        Write-Host "Java atualizado para a versao $latest_version"

} else {
    Write-Host "Versão atual do Java: $java_version"

    # Fazendo o download do Java e salvando no caminho especificado
    Invoke-WebRequest -Uri $java_download_url -OutFile $java_installer_path

    # Verificando nas propriedades do .exe a versão do java instalado com a versão atual
    $latest_version = Get-ChildItem $java_installer_path | ForEach-Object {$_.VersionInfo} | Select-Object *
    $latest_version = "1."+ $latest_version.FileVersion
    $latest_version.ToString()
    $latest_version = $latest_version.Substring(0,3)

    # Comparando as versões e executando a instalação do Java
    if ($java_version -lt $latest_version) {
        Write-Host "Java desatualizado. Instalando ultima versao. $latest_version"

        Start-Process -FilePath $java_installer_path -ArgumentList "/s" -Wait
        Write-Host "Java atualizado para a versao $latest_version"
    } else {
        Write-Host "Java ja esta na versao mais recente: $java_version"
    }
}