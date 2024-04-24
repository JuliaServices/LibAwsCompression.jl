using CEnum

"""
    aws_compression_error

Documentation not found.
"""
@cenum aws_compression_error::UInt32 begin
    AWS_ERROR_COMPRESSION_UNKNOWN_SYMBOL = 3072
    AWS_ERROR_END_COMPRESSION_RANGE = 4095
end

"""
    aws_compression_library_init(alloc)

Initializes internal datastructures used by aws-c-compression. Must be called before using any functionality in aws-c-compression.

### Prototype
```c
void aws_compression_library_init(struct aws_allocator *alloc);
```
"""
function aws_compression_library_init(alloc)
    ccall((:aws_compression_library_init, libaws_c_compression), Cvoid, (Ptr{Cvoid},), alloc)
end

"""
    aws_compression_library_clean_up()

Clean up internal datastructures used by aws-c-compression. Must not be called until application is done using functionality in aws-c-compression.

### Prototype
```c
void aws_compression_library_clean_up(void);
```
"""
function aws_compression_library_clean_up()
    ccall((:aws_compression_library_clean_up, libaws_c_compression), Cvoid, ())
end

"""
    aws_huffman_code

Represents an encoded code
"""
struct aws_huffman_code
    pattern::UInt32
    num_bits::UInt8
end

# typedef struct aws_huffman_code ( aws_huffman_symbol_encoder_fn ) ( uint8_t symbol , void * userdata )
"""
Function used to encode a single symbol to an [`aws_huffman_code`](@ref)

# Arguments
* `symbol`:\\[in\\] The symbol to encode
* `userdata`:\\[in\\] Optional userdata ([`aws_huffman_symbol_coder`](@ref).userdata)
# Returns
The code representing the symbol. If this symbol is not recognized, return a code with num\\_bits set to 0.
"""
const aws_huffman_symbol_encoder_fn = Cvoid

# typedef uint8_t ( aws_huffman_symbol_decoder_fn ) ( uint32_t bits , uint8_t * symbol , void * userdata )
"""
Function used to decode a code into a symbol

# Arguments
* `bits`:\\[in\\] The bits to attept to decode a symbol from
* `symbol`:\\[out\\] The symbol found. Do not write to if no valid symbol found
* `userdata`:\\[in\\] Optional userdata ([`aws_huffman_symbol_coder`](@ref).userdata)
# Returns
The number of bits read from bits
"""
const aws_huffman_symbol_decoder_fn = Cvoid

"""
    aws_huffman_symbol_coder

Structure used to define how symbols are encoded and decoded
"""
struct aws_huffman_symbol_coder
    encode::Ptr{aws_huffman_symbol_encoder_fn}
    decode::Ptr{aws_huffman_symbol_decoder_fn}
    userdata::Ptr{Cvoid}
end

"""
    aws_huffman_encoder

Structure used for persistent encoding. Allows for reading from or writing to incomplete buffers.
"""
struct aws_huffman_encoder
    coder::Ptr{aws_huffman_symbol_coder}
    eos_padding::UInt8
    overflow_bits::aws_huffman_code
end

"""
    aws_huffman_decoder

Structure used for persistent decoding. Allows for reading from or writing to incomplete buffers.
"""
struct aws_huffman_decoder
    coder::Ptr{aws_huffman_symbol_coder}
    allow_growth::Bool
    working_bits::UInt64
    num_bits::UInt8
end

"""
    aws_huffman_encoder_init(encoder, coder)

Initialize a encoder object with a symbol coder.

### Prototype
```c
void aws_huffman_encoder_init(struct aws_huffman_encoder *encoder, struct aws_huffman_symbol_coder *coder);
```
"""
function aws_huffman_encoder_init(encoder, coder)
    ccall((:aws_huffman_encoder_init, libaws_c_compression), Cvoid, (Ptr{aws_huffman_encoder}, Ptr{aws_huffman_symbol_coder}), encoder, coder)
end

"""
    aws_huffman_encoder_reset(encoder)

Resets a decoder for use with a new binary stream

### Prototype
```c
void aws_huffman_encoder_reset(struct aws_huffman_encoder *encoder);
```
"""
function aws_huffman_encoder_reset(encoder)
    ccall((:aws_huffman_encoder_reset, libaws_c_compression), Cvoid, (Ptr{aws_huffman_encoder},), encoder)
end

"""
    aws_huffman_decoder_init(decoder, coder)

Initialize a decoder object with a symbol coder.

### Prototype
```c
void aws_huffman_decoder_init(struct aws_huffman_decoder *decoder, struct aws_huffman_symbol_coder *coder);
```
"""
function aws_huffman_decoder_init(decoder, coder)
    ccall((:aws_huffman_decoder_init, libaws_c_compression), Cvoid, (Ptr{aws_huffman_decoder}, Ptr{aws_huffman_symbol_coder}), decoder, coder)
end

"""
    aws_huffman_decoder_reset(decoder)

Resets a decoder for use with a new binary stream

### Prototype
```c
void aws_huffman_decoder_reset(struct aws_huffman_decoder *decoder);
```
"""
function aws_huffman_decoder_reset(decoder)
    ccall((:aws_huffman_decoder_reset, libaws_c_compression), Cvoid, (Ptr{aws_huffman_decoder},), decoder)
end

"""
    aws_huffman_get_encoded_length(encoder, to_encode)

Get the byte length of to\\_encode post-encoding.

# Arguments
* `encoder`:\\[in\\] The encoder object to use
* `to_encode`:\\[in\\] The symbol buffer to encode
# Returns
The length of the encoded string.
### Prototype
```c
size_t aws_huffman_get_encoded_length(struct aws_huffman_encoder *encoder, struct aws_byte_cursor to_encode);
```
"""
function aws_huffman_get_encoded_length(encoder, to_encode)
    ccall((:aws_huffman_get_encoded_length, libaws_c_compression), Csize_t, (Ptr{aws_huffman_encoder}, aws_byte_cursor), encoder, to_encode)
end

"""
    aws_huffman_encode(encoder, to_encode, output)

Encode a symbol buffer into the output buffer.

# Arguments
* `encoder`:\\[in\\] The encoder object to use
* `to_encode`:\\[in\\] The symbol buffer to encode
* `output`:\\[in\\] The buffer to write encoded bytes to
# Returns
AWS\\_OP\\_SUCCESS if encoding is successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_huffman_encode( struct aws_huffman_encoder *encoder, struct aws_byte_cursor *to_encode, struct aws_byte_buf *output);
```
"""
function aws_huffman_encode(encoder, to_encode, output)
    ccall((:aws_huffman_encode, libaws_c_compression), Cint, (Ptr{aws_huffman_encoder}, Ptr{aws_byte_cursor}, Ptr{Cvoid}), encoder, to_encode, output)
end

"""
    aws_huffman_decode(decoder, to_decode, output)

Decodes a byte buffer into the provided symbol array.

# Arguments
* `decoder`:\\[in\\] The decoder object to use
* `to_decode`:\\[in\\] The encoded byte buffer to read from
* `output`:\\[in\\] The buffer to write decoded symbols to. If decoder is set to allow growth, capacity will be increased when necessary.
# Returns
AWS\\_OP\\_SUCCESS if encoding is successful, AWS\\_OP\\_ERR otherwise
### Prototype
```c
int aws_huffman_decode( struct aws_huffman_decoder *decoder, struct aws_byte_cursor *to_decode, struct aws_byte_buf *output);
```
"""
function aws_huffman_decode(decoder, to_decode, output)
    ccall((:aws_huffman_decode, libaws_c_compression), Cint, (Ptr{aws_huffman_decoder}, Ptr{aws_byte_cursor}, Ptr{Cvoid}), decoder, to_decode, output)
end

"""
    aws_huffman_decoder_allow_growth(decoder, allow_growth)

Set whether or not to increase capacity when the output buffer fills up while decoding. This is false by default.

### Prototype
```c
void aws_huffman_decoder_allow_growth(struct aws_huffman_decoder *decoder, bool allow_growth);
```
"""
function aws_huffman_decoder_allow_growth(decoder, allow_growth)
    ccall((:aws_huffman_decoder_allow_growth, libaws_c_compression), Cvoid, (Ptr{aws_huffman_decoder}, Bool), decoder, allow_growth)
end

"""
Documentation not found.
"""
const AWS_C_COMPRESSION_PACKAGE_ID = 3

