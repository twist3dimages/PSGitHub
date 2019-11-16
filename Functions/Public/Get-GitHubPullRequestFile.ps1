﻿function Get-GitHubPullRequestFile {
    <#
    .SYNOPSIS
    This cmdlet lists the files for a pull request.

    .DESCRIPTION
    Lists pull requests for given owner, repository and filter parameters.

    .INPUTS
s    PSGitHub.PullRequest. You can pipe the output of Get-GitHubPullRequest
    LibGit2Sharp.Repository. You can pipe the output of PowerGit's Get-GitRepository
    LibGit2Sharp.Branch. You can pipe the output of PowerGit's Get-GitBranch or Get-GitHead
    LibGit2Sharp.Commit. You can pipe the output of PowerGit's Get-GitCommit
    #>
    [CmdletBinding()]
    [OutputType('PSGitHub.PullRequestFile')]
    param(
        # The owner of the target repository
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Owner,

        # The name of the target repository
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[\w-\.]+$')]
        [Alias('Repository')]
        [ValidateNotNullOrEmpty()]
        [string] $RepositoryName,

        # Number of the pull request
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Number')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Number,

        # Optional base URL of the GitHub API, for example "https://ghe.mycompany.com/api/v3/" (including the trailing slash).
        # Defaults to "https://api.github.com"
        [Uri] $BaseUri = [Uri]::new('https://api.github.com'),
        [Security.SecureString] $Token
    )

    process {
        Invoke-GitHubApi "repos/$Owner/$RepositoryName/pulls/$Number/files" -BaseUri $BaseUri -Token $Token | ForEach-Object { $_ } | ForEach-Object {
            $_.PSTypeNames.Insert(0, 'PSGitHub.PullRequestFile')
            $_
        }
    }
}
