using LibAwsCompression
using Documenter

DocMeta.setdocmeta!(LibAwsCompression, :DocTestSetup, :(using LibAwsCompression); recursive=true)

makedocs(;
    modules=[LibAwsCompression],
    repo="https://github.com/JuliaServices/LibAwsCompression.jl/blob/{commit}{path}#{line}",
    sitename="LibAwsCompression.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://github.com/JuliaServices/LibAwsCompression.jl",
        assets=String[],
        size_threshold=2_000_000, # 2 MB, we generate about 1 MB page
        size_threshold_warn=2_000_000,
    ),
    pages=["Home" => "index.md"],
)

deploydocs(; repo="github.com/JuliaServices/LibAwsCompression.jl", devbranch="main")
