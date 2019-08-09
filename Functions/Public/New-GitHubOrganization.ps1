function New-GitHubOrganization {
    <#
    .Synopsis
    Creates a new GitHub Organization.

    .Parameter Name
    Required. The name of the new GitHub Organization to create.

    .Parameter Administrator
    The GitHub username of the account manages the GitHub organization.

    .Parameter DisplayName
    The organization's display name.

    .Link
    https://twitter.com/michaelsainz
    https://developer.github.com/enterprise/2.17/v3/enterprise-admin/orgs/#create-an-organization
    #>
    [OutputType('PSGitHub.Organization')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Alias('Organization', 'Org')]
        [string[]]$Name,

        [Parameter(Mandatory = $true)]
        [Alias('Admin')]
        [string]$Administrator,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [Parameter(Mandatory = $true)]
        [Security.SecureString]$Token,

        [Parameter(Mandatory = $true)]
        [Alias('ComputerName', 'Host')]
        [string]$HostName
    )
    
    Begin {
        Write-Debug -Message 'Entered Function: New-GitHubOrganization'

        $Uri = "https://$HostName/api/v3/admin/organizations"
    }

    Process {
        foreach ($handle in $Name) {
            $Body = ConvertTo-Json -InputObject @{
                login = $handle
                admin = $Administrator
                profile_name = $Description
            }
            Write-Debug -Message "Current value of Body is: $(Out-String -InputObject $Body)"
            Invoke-GitHubApi -Body $Body -Method 'POST' -Uri $Uri -Token $Token
        }
    }

    End {
        Write-Debug -Message 'Exited Function: New-GitHubOrganization'
    }
}