using Pkg
Pkg.activate(@__DIR__)
Pkg.develop(path=dirname(@__DIR__)) # Add JediSearch if not already added. This will update Project.toml

using Documenter, DocumenterMarkdown, JediSearch

makedocs(sitename="JediSearch", format = Markdown())