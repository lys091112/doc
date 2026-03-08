# svelte与ts的结合使用


## 1. 基础知识

### 1.1 特性
#### 1.1.1 状态
- ``$state()``
- ``$state.raw()``
- ``$derived()`` /监听state的变化，然后更新数据
#### 1.1.2 Bindings
- GroupInput 记录 input 中的 radio 和 checkbox 选择的数据统一放到一个group记录里，然后可以进行处理
- Select Multi 同上诉的 checkbox 可以支持多个，但是select通过结合option可以在选择的元素中表达更多的属性信息 
- 其他标签： <textarea> 富文本标签

- https://svelte.dev/tutorial/svelte/textarea-inputs

-<input bind:innerHTML={xxx} > 用于在input中默认显示xxx文案vim

#### 1.1.3 动画
- Svelte 提供的 easing 函数让过渡和动画效果更自然。这些函数主要在 svelte/easing 模块中，也作为参数出现在 svelte/transition 和 svelte/animate 中,常用的函数如下：

类型	函数名	特点与适用场景
线性	linear	匀速运动，机械、稳定
二次方	quadIn, quadOut, quadInOut	类似二次方运动，温和减速或加速
三次方	cubicIn, cubicOut, cubicInOut	类似三次方运动，变化比二次方更明显,cubicOut 是 tweened 默认值
四次方	quartIn, quartOut, quartInOut	类似四次方运动，效果更强
五次方	quintIn, quintOut, quintInOut	类似五次方运动，效果非常强劲
指数	expoIn, expoOut, expoInOut	以指数方式变化，非常适合表现瞬间爆发或吸收
圆形	circIn, circOut, circInOut	依据圆形函数变化，适合表现弹跳或弹性
后退	backIn, backOut, backInOut	在开始或结束时略有回拉，模拟过冲效果
弹性	elasticIn, elasticOut, elasticInOut	模拟弹簧振荡，生动有趣
正弦	sineIn, sineOut, sineInOut	依据正弦曲线变化，平滑温和

  



## 2. 知识点记录

### 2.1 基础

- ``async`` 和 ``await`` 的作用：async/await通过将异步操作转化为同步代码风格，解决传统回调函数和Promise链式调用导致的“回调地狱”问题，使代码更直观、易维护。async函数自动返回一个Promise对象，无论函数内部是否显式返回值，都能通过await暂停函数执行，直到依赖的异步操作完成。 await关键字只能在async函数内部使用，用于等待Promise对象的解析结果，返回解析后的值或抛出错误。
- ``satisfies``: 用于类型断言，表示一个值满足特定类型的要求，但不进行类型检查。它常用于类型推断和类型保护，确保值符合预期类型，但不强制执行类型检查。

- let count = writable(0) // 用于持久化存储记录数据

- 代码复用
``` html
    // https://svelte.dev/tutorial/svelte/passing-snippets
    <tbody>
		{#snippet monkey(emoji, description)}
			<tr>
				<td>{emoji}</td>
				<td>{description}</td>
				<td>\u{emoji.charCodeAt(0).toString(16)}\u{emoji.charCodeAt(1).toString(16)}</td>
				<td>&amp#{emoji.codePointAt(0)}</td>
			</tr>
		{/snippet}

		{@render monkey('🙈', 'see no evil')}
		{@render monkey('🙉', 'hear no evil')}
		{@render monkey('🙊', 'speak no evil')}
	</tbody>
```

- 带动画的进度条
```html
let progress = new Tween(0, {
		duration: 400,
		easing: cubicOut
});

<progress value={progress.current}></progress>
```
- Spring 是 svelte/motion 模块提供的一个弹簧物理动画工具，它基于弹簧物理模型来驱动值的动画变化，而不仅仅是简单的时间线性变化。

与 tweened 的关键区别
```
特性	spring	tweened
动画模型	弹簧物理模型	                时间线性插值
运动效果	有弹性、有惯性、可能overshoot	平滑、精确、可预测
适用场景	自然交互、物理模拟	            精确的数值变化
参数控制	刚度、阻尼、质量	            持续时间、缓动函数

```




### 2.2 sveltekit 标签解释

1. ``use:enhance``
在form表单中，用于增强表单功能，最基本的就是不会刷新整个form表达，而是重新执行load，实时加载更新数据
``与传统表单的区别``:

    | 特性 | 传统表单 | 使用 use:enhance 的表单 |
    | -- | -- | -- |
    | 页面刷新 | 是 | 否 |
    | JavaScript 依赖|	不需要	|需要，但有回退|
    | 提交状态跟踪	|手动实现	|自动管理|
    | 错误处理	|全页面显示|	局部更新|
    | SEO 友好性	|高	|高|

2. ``'$app/state'`` 
- 包含 ``page`` ， ``navigating``, ``updated`` 三个只读对象。用于获取和设置应用程序的状态，包括页面标题、页面描述、页面关键字等。它提供了一种方便的方式来管理应用程序的状态，而无需手动操作DOM或使用其他状态管理库。

3. handle 和 handleFetch 这两个hooks的区别
- handle —— 主请求处理器, 作用:
    - 拦截所有 HTTP 请求，用于全局修改请求或响应
    - 在请求到达页面渲染前执行
    - 常用于：身份验证、重定向、修改响应头、日志记录等

    执行时机：客户端请求 - handle -路由匹配 - 页面渲染

- handleFetch -- 请求代理处理器 作用:
    - 拦截 load 函数或表单动作中的 fetch 调用
    - 仅针对服务器端发起的 fetch 请求（不包括客户端 fetch）
    - 常用于：修改 API 请求头、代理请求、统一错误处理，实现请求缓存、跨域请求，请求重试 等

    执行时机：页面load/form action - fetch - handleFetch - 外部api


    | 特性 | handle | handleFetch |
    | -- | -- | -- |
    | 拦截对象	| 所有 HTTP 请求 |	仅服务器端发起的 fetch 调用 |
    | 执行阶段	| 请求生命周期的最外层	| 在 load 或表单动作内部触发 |
    | 修改目标	| 请求/响应对象	特定的  | fetch 请求 |
    | 常见用途	| 全局路由控制、头修改	| API 请求代理、认证注入 |
    | 访问客户端请求	| 是（通过 event）|	否（只处理服务器端 fetch） |

4. ``data-sveltekit-preload-data`` ``data-sveltekit-preload-code`` 及 ``data-sveltekit-reload`` 的应用
 - ``data-sveltekit-preload-data`` 通过在链接（<a> 标签）上添加，需消耗带宽，通常用在静态、半静态的网页上。
   - 预加载页面数据：在用户实际点击链接前，提前获取目标页面的数据
   - 减少加载延迟：实现近乎即时的页面切换体验
   - 控制预加载时机：精确决定何时触发数据预获取

| 属性值 | 触发时机 | 适用场景 |
| -- | -- | -- |
| "hover" (默认)	|鼠标悬停在链接上时| 	常规链接（平衡性能和带宽）|
| "tap"	| 手指触摸/鼠标按下时（点击前）| 	移动端优先的页面|
| "off"	| 禁用预加载| 	低带宽环境或敏感操作链接|
| "true" or "" | 	立即预加载（页面加载后立即开始）| 	高优先级页面（如主导航）|

- ``data-sveltekit-preload-code`` 同样只用于<a> 标签，属性值同上 
  - 预加载页面组件代码：在用户实际导航前，提前加载目标页面的 JavaScript 模块
  - 加速页面切换：减少首次渲染的等待时间
  - 控制代码预加载时机：比数据预加载更轻量级，只加载 JS 不触发数据请求

两者对比如下：
| 特性 |	data-sveltekit-preload-code |	data-sveltekit-preload-data |
| -- | -- | -- |
| 预加载内容 |	仅 JavaScript 模块代码	 | 页面数据（通过 load 函数获取） |
| 网络消耗	|较小（通常 10-100KB） | 	较大（依赖 API 返回数据量） |
| 执行代价	 | 仅下载不执行	会执行 load |  函数和数据处理 |
| 最佳搭配 | 	静态页面或代码分割明显的页面 | 	数据密集型页面 |

- ``data-sveltekit-reload``     绕过 SvelteKit 的客户端路由，触发浏览器标准的页面刷新, 完全重置应用状态（清空内存中的 Svelte 组件树）, 适用于需要完全重新加载页面的特殊场景， 如：登录/登出、重置应用状态，切换主题，页面缓存等。svelte在导航栏添加该属性，用于在导航页面切换时，刷新页面，避免页面状态的残留。

```html
<nav data-sveltekit-reload>
    <a href="/" >Home</a>
    <a href="/about" >About</a>
</nav>
```
5. 路径选择
 - ``[[blog]]`` 用于代表该路径为动态路径,可匹配任何路径,也可以为空
 - [...rest] —— 必需捕获（必须匹配至少一个路径段）
 - ``(auth)`` -- 路径组(不匹配任何路径,相当与一层隐式的路径),如将需要登录的页面放到该路径下,然后在该路径下的+layout.server.ts中校验登录态,非该路径下的页面不校验
 - ``+page@.svelte``  用于 1.绕过父级布局,使当前页面不受父路由布局的约束 2.创建独立渲染层,完全控制页面的根级 HTML 结构 3.实现布局"穿透"适用于需要特殊样式的页面（如全屏页面、弹窗等）, 如:原始路径 /a/b/c ,在c下的``+page@.svelte`` 会使用root级的+layout.svelte结构, c下的``+page@a.svelte`` 会使用a级的+layout.svelte结构
 - ``invalidate()`` 数据失效刷新工具,
   - 主动刷新数据：SvelteKit 会自动跟踪 load 函数中使用的 fetch 请求，建立依赖关系图。 强制重新执行页面的 ``load`` 函数 ,如:``invalidate('/api/now')`` 会强制刷新 /api/now 的数据
   - 保持数据同步：当应用状态变化后更新关联数据
   - 替代全局刷新：实现局部数据更新（无需整页重载）
   - 可以和depends("${flagname}") 结合使用,实现本地数据依赖刷新,如
    ```ts
    // +layout.ts
        export const load = ({depends}) => {
            depends.('date.now');
            return {
                now: Date.now(),
            };
        
        }
        
        // + page.sevlte
        <script>
            import { onMount } from 'svelte';
            import { invalidate } from '$app/navigation';
            let data = $props();

            onMount(() => {
                // 组件挂载后,每隔1s,更新调用下该api
                const interval = setInterval(() => {
                    invalidate('/api/now');
                }, 1000);

                return () => {
                    clearInterval(interval);
                };
            });
        </script>

        <h1>
            {new Intl.DateTimeFormat([], {
                timeStyle: 'full',
                timeZone: data.timezone
            }).format(new Date(data.now))}
        </h1>

    ```

6. onMount 和 beforeNavigate 的区别
- onMount 用于在组件挂载后执行一些操作，通常用于初始化数据、订阅事件等。它会在组件挂载后立即执行，不会等待页面导航完成。例如:
  ``` ts
    onMount(() => {
        // 组件挂载后,每隔1s,更新调用下该api
		const interval = setInterval(() => {
			invalidate('/api/now');
		}, 1000);

		return () => {
			clearInterval(interval);
		};
	});
  ```
- beforeNavigate 用于在页面导航前执行一些操作，通常用于取消订阅事件、清理资源等。它会在页面导航前执行，可以阻止导航或修改导航行为。
