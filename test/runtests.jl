using Test, Aqua, LibAwsCompression, LibAwsCommon

@testset "LibAwsCompression" begin
    @testset "aqua" begin
        Aqua.test_all(LibAwsCompression, ambiguities=false)
        Aqua.test_ambiguities(LibAwsCompression)
    end
    @testset "basic usage to test the library loads" begin
        alloc = aws_default_allocator() # important! this shouldn't need to be qualified! if we generate a definition for it in LibAwsCompression that is a bug.
        aws_compression_library_init(alloc)
    end
end
