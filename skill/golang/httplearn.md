# golang http learn 


golang http 执行流程
```
 var DefaultMux = NewServerMux()
 
 DafaultMux.HandFunc(pattern,handleFun(w,r))
 func (mux *ServeMux) HandleFunc(pattern string, handler func(ResponseWriter, *Request)) {
     mux.Handle(pattern, HandlerFunc(handler))
 }
 在这个函数里面把前面传进来的handler 函数转换成 HandlerFunc
 而 HandlerFunc的类型如下:
 type HandlerFunc func(ResponseWriter, *Request)
 // ServeHTTP calls f(w, r).
 func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
     f(w, r)
     }
 HandlerFunc类型实现了方法 ServeHTTP

再跟进Handle函数
func (mux *ServeMux) Handle(pattern string, handler Handler) {
    mux.mu.Lock()   // 因为map是全局的,涉及到全局调用,因此加锁
    defer mux.mu.Unlock()
    if pattern == "" {
        panic("http: invalid pattern " + pattern)
    }
    if handler == nil {
        panic("http: nil handler")
    }
    if mux.m[pattern].explicit {
        panic("http: multiple registrations for " + pattern)
    }
    mux.m[pattern] = muxEntry{explicit: true, h: handler, pattern: pattern} // 这里注册路由


err := http.ListenAndServe(":8080",nil)解读
跟进函数ListenAndServe,内容如下
func ListenAndServe(addr string, handler Handler) error {
    server := &Server{Addr: addr, Handler: handler}
    return server.ListenAndServe()
}
而参数 Handler 是一个接口,内容如下
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
看到 server := &Server{Addr: addr, Handler: handler} 这句
因为我们在调用ListenAndServe时,第二个参数是nil,所以这里的handle是nil
继续跟进ListenAndServe内容如下
func (srv *Server) ListenAndServe() error {
    addr := srv.Addr
    if addr == "" {
        addr = ":http"
    }
    ln, err := net.Listen("tcp", addr)  // 在这里调用了tcp监听了
    if err != nil {
        return err
    }
    return srv.Serve(tcpKeepAliveListener{ln.(*net.TCPListener)})
}
跟进 Serve,可以看到在该函数里面调用了rw, e := l.Accept(),在接受连接的函数
并且每一个连接 go c.serve() 创建了一个携程
跟进 c.serve() 可以看到在函数里面对请求调用了 ServeHTTP
serverHandler{c.server}.ServeHTTP(w, w.req) 
跟进去内容如下
func (sh serverHandler) ServeHTTP(rw ResponseWriter, req *Request) {
    handler := sh.srv.Handler
    if handler == nil { // 在在这里判断用哪个 handler了
        handler = DefaultServeMux
    }
    if req.RequestURI == "*" && req.Method == "OPTIONS" {
        handler = globalOptionsHandler{}
    }
    handler.ServeHTTP(rw, req)
}
很显然看出了,如果在调用err:=http.ListenAndServe(":8080",nil)时,第二个参数是
我们自定义的Handler的话则调用我们的,否则的话就默认调用 DefaultServeMux
由此可以看出,如果我们要自定义Handler的话只要实现ServeHTTP(ResponseWriter, *Request)方法即可

```
