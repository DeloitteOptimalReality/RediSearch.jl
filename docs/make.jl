using Pkg
Pkg.activate(@__DIR__)
Pkg.develop(path=dirname(@__DIR__)) # Add RediSearch if not already added. This will update Project.toml

using Documenter, DocumenterMarkdown, RediSearch

makedocs(sitename="RediSearch", format = Markdown())