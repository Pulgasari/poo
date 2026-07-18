
Io_Reader :: struct {
    read: proc(self: ^Object, buf: []u8) -> (int, bool), // liest Bytes
}
Io_Writer :: struct {
    write: proc(self: ^Object, data: []u8) -> bool,
}
