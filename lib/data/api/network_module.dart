import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class _NetworkModule {
  static Dio _createDefaultDio() {
    Dio dio = Dio(BaseOptions(

        /// 发送数据的超时设置。
        ///
        /// 超时时会抛出类型为 [DioExceptionType.sendTimeout] 的
        /// [DioException]。
        ///
        /// `null` 或 `Duration.zero` 即不设置超时。
        //Duration ? sendTimeout;

        /// 接收数据的超时设置。
        ///
        /// 这里的超时对应的时间是：
        ///  - 在建立连接和第一次收到响应数据事件之前的超时。
        ///  - 每个数据事件传输的间隔时间，而不是接收的总持续时间。
        ///
        /// 超时时会抛出类型为 [DioExceptionType.receiveTimeout] 的
        /// [DioException]。
        ///
        /// `null` 或 `Duration.zero` 即不设置超时。
        //Duration ? receiveTimeout;

        /// 可以在 [Interceptor]、[Transformer] 和
        /// [Response.requestOptions] 中获取到的自定义对象。
        //Map<String, dynamic> ? extra;

        /// HTTP 请求头。
        ///
        /// 请求头的键是否相等的判断大小写不敏感的。
        /// 例如：`content-type` 和 `Content-Type` 会视为同样的请求头键。
        //Map<String, dynamic> ? headers;

        /// 是否保留请求头的大小写。
        ///
        /// 默认值为 false。
        ///
        /// 该选项在以下场景无效：
        ///  - XHR 不支持直接处理。
        ///  - 按照 HTTP/2 的标准，只支持小写请求头键。
        //bool ? preserveHeaderCase;

        /// 表示 [Dio] 处理请求响应数据的类型。
        ///
        /// 默认值为 [ResponseType.json]。
        /// [Dio] 会在请求响应的 content-type
        /// 为 [Headers.jsonContentType] 时自动将响应字符串处理为 JSON 对象。
        ///
        /// 在以下情况时，分别使用：
        ///  - `plain` 将数据处理为 `String`；
        ///  - `bytes` 将数据处理为完整的 bytes。
        ///  - `stream` 将数据处理为流式返回的二进制数据；
        //ResponseType? responseType;

        /// 请求的 content-type。
        ///
        /// 请求默认的 `content-type` 会由 [ImplyContentTypeInterceptor]
        /// 根据发送数据的类型推断。它可以通过
        /// [Interceptors.removeImplyContentTypeInterceptor] 移除。
        //String? contentType;

        /// 判断当前返回的状态码是否可以视为请求成功。
        //ValidateStatus? validateStatus;

        /// 是否在请求失败时仍然获取返回数据内容。
        ///
        /// 默认为 true。
        //bool? receiveDataWhenStatusError;

        /// 参考 [HttpClientRequest.followRedirects]。
        ///
        /// 默认为 true。
        //bool? followRedirects;

        /// 当 [followRedirects] 为 true 时，指定的最大重定向次数。
        /// 如果请求超出了重定向次数上线，会抛出 [RedirectException]。
        ///
        /// 默认为 5。
        //int? maxRedirects;

        /// 参考 [HttpClientRequest.persistentConnection]。
        ///
        /// 默认为 true。
        //bool? persistentConnection;

        /// 对请求内容进行自定义编码转换。
        ///
        /// 默认为 [Utf8Encoder]。
        //RequestEncoder? requestEncoder;

        /// 对请求响应内容进行自定义解码转换。
        ///
        /// 默认为 [Utf8Decoder]。
        //ResponseDecoder? responseDecoder;

        /// 当请求参数以 `x-www-url-encoded` 方式发送时，如何处理集合参数。
        ///
        /// 默认为 [ListFormat.multi]。
        //ListFormat? listFormat;
        ));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      enabled: true,
    ));
    return dio;
  }

  static Dio _createFileDio() {
    Dio dio = Dio(BaseOptions(
      sendTimeout: const Duration(seconds: 60 * 30), //半个小时
    ));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      enabled: true,
    ));
    return dio;
  }
}

final defaultDio = _NetworkModule._createDefaultDio();

final fileDio = _NetworkModule._createFileDio();
