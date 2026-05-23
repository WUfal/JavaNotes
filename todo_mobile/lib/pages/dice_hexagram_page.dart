import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as v64;

void main() {
  runApp(const AppRoot());
}

// --- 1. 古风配色系统 ---
const Color kRicePaperBase = Color(0xFFEFE6D6); // 宣纸底色
const Color kRicePaperDim  = Color(0xFFD3C3A8); // 边缘陈旧色
const Color kInkLight      = Color(0x993E3E3E); // 淡墨
const Color kInkDark       = Color(0xFF1A1A1A); // 浓墨
const Color kCinnabar      = Color(0xFFB73636); // 朱砂红 (印章/点数)
const Color kBambooLight   = Color(0xFFE3D6AA); // 竹简亮部
const Color kBambooDark    = Color(0xFFC7B27C); // 竹简暗部
const Color kJadeWhite     = Color(0xFFFDFBF2); // 羊脂玉骰子底色

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.transparent, // 由画笔接管背景
        fontFamily: 'Serif', // 衬线体，更有文化感
      ),
      home: const OraclePage(),
    );
  }
}

// --- 2. 数据模型 ---
class Fortune {
  final String level;
  final String title;
  final String poem;
  final String advice;
  const Fortune({required this.level, required this.title, required this.poem, required this.advice});
}

final Map<int, Fortune> kFortunes = {
  3: const Fortune(level: "下下", title: "潜龙勿用", poem: "寒潭深处且藏锋，时运未至莫强通。", advice: "静守孤灯，不宜妄动。"),
  4: const Fortune(level: "下平", title: "困鸟在笼", poem: "樊笼虽设心未死，羽翼初丰待风起。", advice: "修身养性，静待锁钥自开。"),
  5: const Fortune(level: "中平", title: "云遮月影", poem: "清辉暂被浮云掩，风过云散月复明。", advice: "耐心等候，真相自会显现。"),
  6: const Fortune(level: "小吉", title: "枯木逢春", poem: "严冬已过春信至，老树新芽向阳生。", advice: "转机已现，生机勃勃。"),
  7: const Fortune(level: "中吉", title: "行舟顺水", poem: "轻舟短棹任流转，两岸猿声送客归。", advice: "顺势而为，事半功倍。"),
  8: const Fortune(level: "中平", title: "静水流深", poem: "波澜不惊心自定，深水无声藏万金。", advice: "保持低调，切勿张扬。"),
  9: const Fortune(level: "小吉", title: "登高望远", poem: "欲穷千里目中景，更上一层楼外楼。", advice: "跳出琐事，做长远规划。"),
  10: const Fortune(level: "平", title: "中正平和", poem: "不偏不倚行大道，无咎无誉保平安。", advice: "维持现状，中庸之道。"),
  11: const Fortune(level: "大吉", title: "旭日东升", poem: "曈曈红日出沧海，万国衣冠拜冕旒。", advice: "气运正盛，大胆施展。"),
  12: const Fortune(level: "小吉", title: "花开见佛", poem: "因缘具足花初放，福报随身喜气多。", advice: "善因结善果，即将兑现。"),
  13: const Fortune(level: "中吉", title: "锦上添花", poem: "红尘紫陌铺锦绣，好风凭借上青云。", advice: "此时宜进取，忌犹豫。"),
  14: const Fortune(level: "上上", title: "紫气东来", poem: "祥云瑞气盈门庭，吉星高照万事兴。", advice: "天时地利人和，如有神助。"),
  15: const Fortune(level: "中吉", title: "金玉满堂", poem: "良田万顷收成好，仓廪实而知礼节。", advice: "收获颇丰，懂得知足分享。"),
  16: const Fortune(level: "大吉", title: "鹏程万里", poem: "大鹏一日同风起，扶摇直上九万里。", advice: "宏图大展，志在四方。"),
  17: const Fortune(level: "上吉", title: "众星拱月", poem: "德厚流光人所敬，群贤毕至道方隆。", advice: "以德服人，众望所归。"),
  18: const Fortune(level: "至尊", title: "乾坤定矣", poem: "九五之尊当时位，天下谁人不识君。", advice: "巅峰状态，持盈保泰。"),
};

// --- 3. 物理实体 ---
class DiceBody3D {
  int id;
  Offset pos;
  Offset velocity;
  double angleX, angleY, angleZ;
  double spinX, spinY, spinZ;
  int finalValue;
  DiceBody3D({required this.id, required this.pos, this.velocity = Offset.zero, this.angleX = 0, this.angleY = 0, this.angleZ = 0, this.spinX = 0, this.spinY = 0, this.spinZ = 0, this.finalValue = 1});
}

enum OracleState { idle, aligning, ready, resultShown }

class OraclePage extends StatefulWidget {
  const OraclePage({super.key});

  @override
  State<OraclePage> createState() => _OraclePageState();
}

class _OraclePageState extends State<OraclePage> with TickerProviderStateMixin {
  late Ticker _physicsTicker;
  late AnimationController _alignController;

  OracleState _state = OracleState.idle;

  // 物理变量
  Offset _bowlVelocity = Offset.zero;
  Offset _bowlTilt = Offset.zero;
  Offset _bowlShakeOffset = Offset.zero;
  Offset _lastDragPos = Offset.zero;
  int _hapticCounter = 0;

  final double _bowlRadius = 140.0;
  final double _diceSize = 64.0;
  List<DiceBody3D> _dices = [];
  List<DiceBody3D> _snapshotDices = []; // 用于动画插值

  // 游戏逻辑
  double _energy = 0.0;
  Fortune? _currentFortune;
  int _totalSum = 0;

  @override
  void initState() {
    super.initState();
    // 沉浸式设置
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 浅色背景用深色图标
    ));

    _initDices();

    _physicsTicker = createTicker(_onPhysicsTick)..start();

    _alignController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _alignController.addListener(() => setState(() {}));
    _alignController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _state = OracleState.ready);
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _initDices() {
    _dices = [
      DiceBody3D(id: 0, pos: const Offset(-45, -30)),
      DiceBody3D(id: 1, pos: const Offset(45, -30)),
      DiceBody3D(id: 2, pos: const Offset(0, 50)),
    ];
  }

  @override
  void dispose() {
    _physicsTicker.dispose();
    _alignController.dispose();
    super.dispose();
  }

  // --- 4. 物理引擎 (复用之前的高级逻辑) ---
  void _onPhysicsTick(Duration elapsed) {
    if (!mounted) return;
    if (_state != OracleState.idle) {
      _bowlTilt = Offset.lerp(_bowlTilt, Offset.zero, 0.1)!;
      _bowlShakeOffset = Offset.zero;
      return;
    }

    setState(() {
      // 碗
      _bowlVelocity *= 0.92;
      if (_bowlVelocity.distance < 0.1) {
        _bowlVelocity = Offset.zero;
        _bowlShakeOffset = Offset.zero;
      } else {
        double jitter = math.min(_bowlVelocity.distance * 0.2, 8.0);
        _bowlShakeOffset = Offset((math.Random().nextDouble()-0.5)*jitter, (math.Random().nextDouble()-0.5)*jitter);
      }
      double tx = _bowlVelocity.dy * 0.003;
      double ty = -_bowlVelocity.dx * 0.003;
      _bowlTilt += Offset((tx - _bowlTilt.dx) * 0.15, (ty - _bowlTilt.dy) * 0.15);

      // 能量
      double speed = _bowlVelocity.distance;
      if (speed > 4.0) {
        _energy += speed * 0.06;
        if (_energy >= 100) { _energy = 100; _prepareToAlign(); }
      } else if (speed < 1.0 && _energy > 0) {
        _energy = math.max(0, _energy - 0.5);
      }

      // 骰子运动
      for (var dice in _dices) {
        if (_bowlVelocity != Offset.zero) {
          dice.velocity -= _bowlVelocity * (0.12 + math.Random().nextDouble() * 0.05);
        }
        dice.velocity *= 0.98;
        dice.pos += dice.velocity;

        if (dice.velocity.distance > 0.2) {
          dice.spinX = dice.velocity.dy * 0.06;
          dice.spinY = -dice.velocity.dx * 0.06;
          dice.spinZ = (math.Random().nextDouble()-0.5)*0.1;
        } else {
          dice.spinX *= 0.9; dice.spinY *= 0.9; dice.spinZ *= 0.9;
        }
        dice.angleX += dice.spinX; dice.angleY += dice.spinY; dice.angleZ += dice.spinZ;
      }

      // 碰撞与边界
      for (int k = 0; k < 8; k++) {
        double rLimit = _bowlRadius - _diceSize * 0.6;
        for (var dice in _dices) {
          double dist = dice.pos.distance;
          if (dist > rLimit) {
            Offset n = dice.pos / dist;
            dice.pos = n * rLimit;
            double dot = dice.velocity.dx * n.dx + dice.velocity.dy * n.dy;
            if (dot > 0) {
              dice.velocity -= n * (1.7 * dot);
              dice.spinX += (math.Random().nextDouble()-0.5)*0.5;
            }
          }
        }
        double minDist = _diceSize * 1.05;
        for (int i = 0; i < _dices.length; i++) {
          for (int j = i + 1; j < _dices.length; j++) {
            var d1 = _dices[i]; var d2 = _dices[j];
            Offset delta = d1.pos - d2.pos;
            double dist = delta.distance;
            if (dist < minDist) {
              if (dist < 0.001) { delta = const Offset(1, 0); dist = 1.0; }
              Offset n = delta / dist;
              Offset sep = n * ((minDist - dist) * 0.5);
              d1.pos += sep; d2.pos -= sep;
              Offset rv = d1.velocity - d2.velocity;
              double vn = rv.dx * n.dx + rv.dy * n.dy;
              if (vn < 0) {
                Offset impulse = n * (-(1.9) * vn / 2);
                d1.velocity += impulse; d2.velocity -= impulse;
                d1.spinX += (math.Random().nextDouble()-0.5)*0.3;
              }
            }
          }
        }
      }

      if (_bowlVelocity.distance > 5 && _hapticCounter++ > 4) {
        HapticFeedback.lightImpact();
        _hapticCounter = 0;
      }
    });
  }

  void _prepareToAlign() async {
    final rng = math.Random();
    int d1 = rng.nextInt(6) + 1; int d2 = rng.nextInt(6) + 1; int d3 = rng.nextInt(6) + 1;
    _totalSum = d1 + d2 + d3;
    _currentFortune = kFortunes[_totalSum];
    _dices[0].finalValue = d1; _dices[1].finalValue = d2; _dices[2].finalValue = d3;

    _snapshotDices = _dices.map((d) => DiceBody3D(
        id: d.id, pos: d.pos,
        angleX: d.angleX % (2*math.pi), angleY: d.angleY % (2*math.pi), angleZ: d.angleZ % (2*math.pi),
        finalValue: d.finalValue
    )).toList();

    _state = OracleState.aligning;
    HapticFeedback.heavyImpact();
    _alignController.forward();
  }

  void _onPanStart(DragStartDetails details) {
    if (_state != OracleState.idle) return;
    _lastDragPos = details.globalPosition;
  }
  void _onPanUpdate(DragUpdateDetails details) {
    if (_state != OracleState.idle) return;
    Offset delta = details.globalPosition - _lastDragPos;
    _bowlVelocity += delta * 1.5;
    _lastDragPos = details.globalPosition;
  }
  void _reset() {
    setState(() {
      _state = OracleState.idle; _energy = 0; _currentFortune = null;
      _alignController.reset(); _initDices();
    });
  }

  // --- 5. 渲染构建 (Z-Sorted) ---
  List<Widget> _buildSortedDices() {
    List<_RenderableDice> renderList = [];
    final Matrix4 bowlMat = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..rotateX(_bowlTilt.dx)
      ..rotateY(_bowlTilt.dy);

    for (int i = 0; i < _dices.length; i++) {
      var dice = _dices[i];
      Offset pos = dice.pos;
      double ax = dice.angleX, ay = dice.angleY, az = dice.angleZ;

      if (_state == OracleState.aligning || _state == OracleState.ready || _state == OracleState.resultShown) {
        List<Offset> tg = [const Offset(-90, -10), const Offset(0, -10), const Offset(90, -10)];
        double t = Curves.easeInOutBack.transform(_alignController.value);
        if (_snapshotDices.isNotEmpty) {
          var start = _snapshotDices[i];
          pos = Offset.lerp(start.pos, tg[i], t)!;
          ax = lerpDouble(start.angleX, 0, t)!;
          ay = lerpDouble(start.angleY, 0, t)!;
          az = lerpDouble(start.angleZ, (i-1)*0.2, t)!;
        }
      }

      final v64.Vector3 vec = v64.Vector3(pos.dx, pos.dy, 0);
      final v64.Vector3 transformed = bowlMat.transformed3(vec);

      renderList.add(_RenderableDice(
          zIndex: transformed.z,
          widget: Positioned(
            left: 150 + pos.dx - (_diceSize/2),
            top: 150 + pos.dy - (_diceSize/2),
            child: JadeDiceWidget( // 使用新的暖玉材质
              size: _diceSize,
              ax: ax, ay: ay, az: az,
              val: dice.finalValue,
            ),
          )
      ));
    }
    renderList.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return renderList.map((e) => e.widget).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 碗的 3D 变换
    Matrix4 bowlMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0015)
      ..translate(_bowlShakeOffset.dx, _bowlShakeOffset.dy)
      ..rotateX(_bowlTilt.dx)
      ..rotateY(_bowlTilt.dy);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onTap: _state == OracleState.resultShown ? null : () {},
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ================== 层级 1: 动态程序化背景 ==================
            // 1. 古卷宣纸层
            Positioned.fill(
              child: CustomPaint(painter: AncientScrollPainter()),
            ),

            // 2. 竹简底部装饰 (固定高度 20%)
            Positioned(
              bottom: 0, left: 0, right: 0,
              height: size.height * 0.22,
              child: CustomPaint(painter: BambooSlipPainter()),
            ),

            // 3. 后天八卦 (居中, 淡墨效果)
            Positioned(
              top: size.height * 0.25,
              child: Opacity(
                opacity: 0.7,
                child: CustomPaint(
                  size: Size(size.width * 0.8, size.width * 0.8),
                  painter: BaguaPainter(),
                ),
              ),
            ),

            // ================== 层级 2: UI 标题层 ==================
            Positioned(
              top: MediaQuery.of(context).padding.top + 30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: (_state == OracleState.idle || _state == OracleState.aligning ? 1.0 : 0.0).clamp(0.0, 1.0),
                child: Column(
                  children: [
                    // 书法标题组件
                    const InkTitleWidget(text: "问卦"),
                    const SizedBox(height: 10),
                    // 红色印章
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: kCinnabar.withOpacity(0.8), width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text("灵龟", style: TextStyle(color: kCinnabar, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4)),
                    ),
                    const SizedBox(height: 20),
                    // 进度条 (改为竹节风格)
                    if (_energy > 0)
                      Container(
                        width: 200, height: 4,
                        decoration: BoxDecoration(color: kInkLight.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (_energy / 100).clamp(0.0, 1.0),
                          child: Container(decoration: BoxDecoration(color: kCinnabar, borderRadius: BorderRadius.circular(2))),
                        ),
                      )
                  ],
                ),
              ),
            ),

            // ================== 层级 3: 核心碗与骰子 ==================
            Align(
              alignment: const Alignment(0, -0.1),
              child: Transform(
                transform: bowlMatrix,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 360, height: 360,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 碗阴影 (柔和的宣纸阴影)
                      Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: kInkDark.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 20))])),

                      // 碗 (半透明磨砂玻璃感 + 古铜边)
                      Container(
                        width: 300, height: 300,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kRicePaperBase.withOpacity(0.3), // 半透明
                            border: Border.all(color: kInkDark.withOpacity(0.2), width: 1),
                            gradient: RadialGradient(
                                colors: [Colors.white.withOpacity(0.1), kInkLight.withOpacity(0.1)],
                                stops: const [0.0, 1.0]
                            )
                        ),
                      ),

                      // 骰子 (羊脂玉材质)
                      ..._buildSortedDices(),

                      // 碗口光泽
                      IgnorePointer(child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withOpacity(0.2), Colors.transparent], stops: const [0, 0.4])))),
                    ],
                  ),
                ),
              ),
            ),

            // ================== 层级 4: 结果与交互 ==================
            if (_state == OracleState.ready)
              Positioned(
                bottom: 120,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0), duration: const Duration(milliseconds: 600), curve: Curves.elasticOut,
                  builder: (ctx, val, child) => Transform.scale(scale: val, child: child),
                  child: GestureDetector(
                    onTap: () { HapticFeedback.mediumImpact(); setState(() => _state = OracleState.resultShown); },
                    child: Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: kCinnabar, boxShadow: [BoxShadow(color: kCinnabar.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 5))]),
                      child: const Center(child: Text("解", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Serif'))),
                    ),
                  ),
                ),
              ),

            if (_state == OracleState.resultShown)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () { HapticFeedback.selectionClick(); _reset(); },
                  child: Container(
                    color: Colors.black.withOpacity(0.6), // 遮罩
                    alignment: Alignment.center,
                    child: _buildResultCard(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 结果卡片 - 仿古签文风格
  Widget _buildResultCard() {
    if (_currentFortune == null) return const SizedBox();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0), duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic,
      builder: (ctx, val, child) => Transform.scale(scale: 0.9 + 0.1*val, child: Opacity(opacity: val, child: child)),
      child: Container(
        width: 300, padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        decoration: BoxDecoration(
          color: kRicePaperBase,
          borderRadius: BorderRadius.circular(4), // 纸张圆角小
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30)],
          image: const DecorationImage(image: NetworkImage(""), fit: BoxFit.cover), // 这里可以用纸张纹理图
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_currentFortune!.level, style: const TextStyle(color: kCinnabar, fontSize: 18, letterSpacing: 6, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(_currentFortune!.title, style: const TextStyle(color: kInkDark, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
            const SizedBox(height: 30),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(_currentFortune!.poem, textAlign: TextAlign.center, style: const TextStyle(color: kInkDark, fontSize: 20, height: 1.6, fontFamily: 'Serif'))),
            const SizedBox(height: 30),
            Container(width: 50, height: 2, color: kCinnabar.withOpacity(0.5)),
            const SizedBox(height: 30),
            Text(_currentFortune!.advice, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF5D4037), fontSize: 15)),
            const SizedBox(height: 20),
            Text("点击空白处收起", style: TextStyle(color: kInkLight.withOpacity(0.5), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// --- 5. 墨迹晕染书法标题组件 ---
// ---------------------------------------------------------------------------
class InkTitleWidget extends StatelessWidget {
  final String text;
  const InkTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 墨晕阴影 (模糊扩散)
        Text(
          text,
          style: TextStyle(
            fontSize: 64, fontFamily: 'Serif', fontWeight: FontWeight.w900,
            foreground: Paint()..style = PaintingStyle.stroke..strokeWidth = 5..color = kInkLight.withOpacity(0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
          ),
        ),
        // 2. 核心墨迹 (浓黑)
        Text(
          text,
          style: TextStyle(
            fontSize: 64, fontFamily: 'Serif', fontWeight: FontWeight.bold, color: kInkDark.withOpacity(0.9),
            shadows: [Shadow(offset: const Offset(2, 2), blurRadius: 2, color: Colors.black.withOpacity(0.1))], // 飞白
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// --- 6. 羊脂暖玉材质骰子 (Jade Texture) ---
// ---------------------------------------------------------------------------
class JadeDiceWidget extends StatelessWidget {
  final double size, ax, ay, az;
  final int val;
  const JadeDiceWidget({super.key, required this.size, required this.ax, required this.ay, required this.az, required this.val});

  @override
  Widget build(BuildContext context) {
    // 3D 变换
    final m = Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(ax)..rotateY(ay)..rotateZ(az);

    // 背面剔除
    final double zx = m[2]; final double zy = m[6]; final double zz = m[10];

    return Transform(
      transform: m, alignment: Alignment.center,
      child: SizedBox(
        width: size, height: size,
        child: Stack(
          children: [
            if (zz < 0) _face(0,0,-size/2,math.pi,0,7-val),
            if (zx < 0) _face(-size/2,0,0,0,-math.pi/2, _l(val)),
            if (zx > 0) _face(size/2,0,0,0,math.pi/2,_r(val)),
            if (zy < 0) _face(0,-size/2,0,-math.pi/2,0,_u(val)),
            if (zy > 0) _face(0,size/2,0,math.pi/2,0,7-_u(val)),
            if (zz > 0) _face(0,0,size/2,0,0,val),
          ],
        ),
      ),
    );
  }
  int _r(int v) { int r=1; while([v,7-v,_u(v),7-_u(v)].contains(r)) r++; return r; }
  int _l(int v) => 7-_r(v);
  int _u(int v) { int u=(v%6)+1; if(u==v||u==7-v) u=((v+1)%6)+1; return u; }

  Widget _face(double x, double y, double z, double rx, double ry, int v) {
    return Transform(
      transform: Matrix4.identity()..translate(x,y,z)..rotateX(rx)..rotateY(ry), alignment: Alignment.center,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: kJadeWhite, // 暖玉白
          borderRadius: BorderRadius.circular(size * 0.15), // 略微圆润，但保留玉石硬度感
          boxShadow: [
            BoxShadow(color: kInkDark.withOpacity(0.1), blurRadius: 2, offset: const Offset(1,1)), // 阴影
            BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 4, offset: const Offset(-1,-1), blurStyle: BlurStyle.inner) // 玉石透光感
          ],
          border: Border.all(color: const Color(0xFFE0D8C0), width: 0.5),
        ),
        child: Center(child: _dots(v)),
      ),
    );
  }
  Widget _dots(int v) {
    // 只有 1 和 4 是朱砂红，其余是墨色
    Color c = (v==1||v==4) ? kCinnabar : kInkDark;
    double s = size*(v==1?0.32:0.2);
    Widget d() => Container(
        width: s, height: s,
        decoration: BoxDecoration(
            color: c.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0.5,0.5), blurRadius: 0.5, blurStyle: BlurStyle.inner),
            ]
        )
    );
    if(v==1) return d();
    if(v==2) return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [d(),d()]);
    if(v==3) return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [d(),d(),d()]);
    if(v==4) return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()]), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()])]);
    if(v==5) return Stack(alignment: Alignment.center, children: [Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()]), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()])]), d()]);
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()]), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()]), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[d(),d()])]);
  }
}

class _RenderableDice {
  final double zIndex;
  final Widget widget;
  _RenderableDice({required this.zIndex, required this.widget});
}

// --- 7. 画笔 (Painters) ---

// 古卷背景：宣纸纹理 + 云气 + 裂纹
class AncientScrollPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // 1. 宣纸底色 (中间亮，边缘旧)
    final paperPaint = Paint()..shader = RadialGradient(colors: [kRicePaperBase, kRicePaperDim], stops: const [0.3, 1.0], center: Alignment.center).createShader(rect);
    canvas.drawRect(rect, paperPaint);

    // 2. 噪点 (模拟纸张杂质)
    final noisePaint = Paint()..color = kInkDark.withOpacity(0.02);
    final rng = math.Random(1);
    for (int i = 0; i < 4000; i++) canvas.drawCircle(Offset(rng.nextDouble()*size.width, rng.nextDouble()*size.height), rng.nextDouble()*1.5, noisePaint);

    // 3. 云气 (极其淡的青灰色)
    final cloudPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 40..color = const Color(0xFF78909C).withOpacity(0.03)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    Path cp = Path();
    cp.moveTo(-50, size.height*0.2); cp.quadraticBezierTo(size.width*0.5, size.height*0.1, size.width+50, size.height*0.3);
    cp.moveTo(-50, size.height*0.6); cp.quadraticBezierTo(size.width*0.5, size.height*0.7, size.width+50, size.height*0.5);
    canvas.drawPath(cp, cloudPaint);

    // 4. 龟甲裂纹
    final crackPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 0.5..color = kInkDark.withOpacity(0.1);
    _drawCrack(canvas, Offset(size.width*0.1, size.height*0.15), crackPaint, rng);
    _drawCrack(canvas, Offset(size.width*0.9, size.height*0.85), crackPaint, rng);
  }
  void _drawCrack(Canvas c, Offset s, Paint p, math.Random r) {
    Path path = Path()..moveTo(s.dx, s.dy);
    Offset cur = s;
    for(int i=0;i<4;i++) { cur+=Offset((r.nextDouble()-0.5)*50, (r.nextDouble()-0.5)*50); path.lineTo(cur.dx, cur.dy); }
    c.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// 竹简底座
class BambooSlipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double slipW = size.width / 12;
    final bPaint = Paint()..color = kBambooLight;
    final shadow = Paint()..color = Colors.black.withOpacity(0.1);
    final light = Paint()..color = Colors.white.withOpacity(0.15);

    for(double x=0; x<size.width; x+=slipW) {
      canvas.drawRect(Rect.fromLTWH(x, 0, slipW-1, size.height), bPaint); // 竹片
      canvas.drawRect(Rect.fromLTWH(x, 0, 2, size.height), light); // 左高光
      canvas.drawRect(Rect.fromLTWH(x+slipW-3, 0, 2, size.height), shadow); // 右阴影
      // 绳子
      _line(canvas, x, size.height*0.2, slipW);
      _line(canvas, x, size.height*0.8, slipW);
    }
    // 文字: 观变玩占 趋吉避凶
    final ts = TextStyle(color: kInkDark.withOpacity(0.35), fontSize: 16, fontFamily: 'Serif', fontWeight: FontWeight.bold);
    _vText(canvas, "观变玩占", size.width*0.25, size.height*0.15, ts, slipW);
    _vText(canvas, "趋吉避凶", size.width*0.65, size.height*0.15, ts, slipW);
  }
  void _line(Canvas c, double x, double y, double w) => c.drawLine(Offset(x, y), Offset(x+w, y+2), Paint()..color=const Color(0xFF5D4037)..strokeWidth=2);
  void _vText(Canvas c, String txt, double sx, double sy, TextStyle s, double w) {
    TextPainter tp = TextPainter(textDirection: TextDirection.ltr);
    for(int i=0; i<txt.length; i++) {
      tp.text = TextSpan(text: txt[i], style: s); tp.layout();
      tp.paint(c, Offset(sx + (i*w*1.2), sy + (i%2==0?0:10))); // 错落感
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// 后天八卦
class BaguaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width/2, size.height/2);
    final r = size.width/2;
    final lp = Paint()..style=PaintingStyle.stroke..strokeWidth=3..color=kInkLight.withOpacity(0.5)..strokeCap=StrokeCap.round;
    final ap = Paint()..style=PaintingStyle.fill..color=kCinnabar.withOpacity(0.6); // 朱砂点

    // 八卦数据 (上爻,中爻,下爻) 1=阳
    final gua = [[1,0,1],[0,0,0],[0,1,1],[1,1,1],[0,1,0],[1,0,0],[0,0,1],[1,1,0]];

    for(int i=0; i<8; i++) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(i * math.pi/4);
      canvas.translate(0, -r*0.75);
      _drawGua(canvas, gua[i], lp, ap);
      canvas.restore();
    }
    // 太极晕
    canvas.drawCircle(c, r*0.3, Paint()..style=PaintingStyle.stroke..color=kInkLight.withOpacity(0.1)..strokeWidth=1);
  }
  void _drawGua(Canvas c, List<int> y, Paint lp, Paint ap) {
    double w = 30; double gap = 6;
    for(int j=0; j<3; j++) {
      double yPos = -(j*gap) + gap;
      if(y[j]==1) {
        c.drawLine(Offset(-w/2, yPos), Offset(w/2, yPos), lp);
        if(j==1) c.drawCircle(Offset(0, yPos), 1.5, ap); // 仅点缀中阳爻
      } else {
        c.drawLine(Offset(-w/2, yPos), Offset(-3, yPos), lp);
        c.drawLine(Offset(3, yPos), Offset(w/2, yPos), lp);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = kInkLight.withOpacity(0.1);
    final rng = math.Random();
    for (int i = 0; i < 300; i++) canvas.drawCircle(Offset(rng.nextDouble()*size.width, rng.nextDouble()*size.height), 1, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

double? lerpDouble(num? a, num? b, double t) { if (a==null||b==null) return null; return a + (b-a)*t; }