$repo = "shiktr1785/cdac_project_group-6_risc-v"
$issues = Get-Content issues.json | ConvertFrom-Json

foreach ($i in $issues) {

    $existing = gh issue list `
        --repo $repo `
        --search "`"$($i.title)`"" `
        --json number,title `
        --jq '.[0].number'

    if ($existing) {
        Write-Host "⏭️  Issue already exists (#$existing): $($i.title)"
        continue
    }

    gh issue create `
        --title $i.title `
        --body $i.body `
        --label ($i.labels -join ",") `
        --assignee $i.assignee `
        --milestone "$($i.milestone)" `
        --repo shiktr1785/cdac_project_group-6_risc-v

    Write-Host "✅ Created issue: $($i.title)"
}