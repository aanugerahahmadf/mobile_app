import 'package:flutter/material.dart';

/// Satu baris aksi di dalam gelembung.
///
/// Label di kiri, ikon di kanan -- mengikuti iOS Messages. Di Material ikonnya
/// biasanya di kiri, tapi gelembung ini sengaja tidak boleh terlihat seperti
/// menu Material: pengguna sudah tahu bentuknya dari aplikasi pesan yang biasa
/// mereka pakai, dan mencampur dua gaya membuat salah satunya terasa asing.
class MessageBubbleAction {
  final String label;
  final IconData icon;
  final bool destructive;
  final VoidCallback onTap;

  const MessageBubbleAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });
}

/// Gelembung aksi pesan ala iOS Messages.
///
/// Dua bagian: deretan emoji melayang (hanya bila [emojis] tidak kosong), lalu
/// daftar aksi memanjang ke bawah. Semuanya digantung di atas titik yang
/// ditekan -- itu urusan [MessageBubbleOverlay], bukan widget ini.
class MessageActionBubble extends StatelessWidget {
  /// Lebar maksimum daftar aksi. Di layar 400px ini menyisakan 40px di kiri dan
  /// kanan, jadi gelembung tidak pernah menempel tepi layar.
  static const double maxPanelWidth = 300;

  static const double _radius = 16;
  static const double _gap = 8;

  /// Warna iOS "system gray 6 dark" untuk isian gelembung. Dipakai apa adanya
  /// di mode terang maupun gelap: gelembung aksi pesan pada iOS tidak pernah
  /// terang, dan latar gelap membuat emoji yang warnanya sudah kuat tetap
  /// terbaca tanpa harus menaikkan kontras teksnya.
  static const Color _surface = Color(0xFF1C1C1E);
  static const Color _divider = Color(0xFF38383A);
  static const Color _label = Colors.white;
  static const Color _icon = Color(0xFF8E8E93);

  final List<String> emojis;
  final List<MessageBubbleAction> actions;
  final ValueChanged<String> onEmoji;

  /// Membuka pemilih emoji lengkap. Tombol "+" hanya dirender kalau ini
  /// non-null: tombol mati lebih buruk daripada tidak ada sama sekali.
  final VoidCallback? onMoreEmojis;

  const MessageActionBubble({
    super.key,
    required this.emojis,
    required this.actions,
    required this.onEmoji,
    this.onMoreEmojis,
  });

  @override
  Widget build(BuildContext context) {
    final showEmojis = emojis.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showEmojis) ...[_emojiPill(), const SizedBox(height: _gap)],
        _actionPanel(),
      ],
    );
  }

  Widget _emojiPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final emoji in emojis)
            GestureDetector(
              onTap: () => onEmoji(emoji),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24, height: 1.2),
                ),
              ),
            ),
          if (onMoreEmojis != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onMoreEmojis,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: _divider,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, size: 20, color: _label),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionPanel() {
    return Container(
      constraints: const BoxConstraints(maxWidth: maxPanelWidth),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(_radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 0.5, color: _divider),
            _actionRow(actions[i]),
          ],
        ],
      ),
    );
  }

  Widget _actionRow(MessageBubbleAction action) {
    final color = action.destructive ? const Color(0xFFFF453A) : _label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  action.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17, color: color),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                action.icon,
                size: 22,
                color: action.destructive ? color : _icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lapisan penuh layar yang menahan gelembung di atas titik yang ditekan.
///
/// Kenapa bukan `showModalBottomSheet` seperti sebelumnya: sheet menutupi
/// separuh layar dan menutupi pesan yang sedang ditahan, jadi tidak ada yang
/// bisa dilihat untuk memutuskan aksi apa yang mau diambil. Gelembung ini hanya
/// menutupi area yang tidak dipilih.
///
/// Penempatan dihitung dalam dua tahap. Tahap pertama memakai perkiraan tinggi
/// supaya gelembung tidak berkedip di tempat yang salah; tahap kedua, setelah
/// frame pertama selesai digambar, mengukur tinggi sebenarnya lalu mengoreksi
/// posisinya. Tanpa tahap kedua, gelembung dengan banyak aksi akan meleset ke
/// bawah tepi layar karena perkiraan awalnya terlalu kecil.
class MessageBubbleOverlay extends StatefulWidget {
  /// Titik layar tempat jari ditekan, dari `onLongPressStart.globalPosition`.
  final Offset anchor;

  final Widget child;

  /// Dipanggil saat pengguna menyentuh area di luar gelembung.
  final VoidCallback onDismiss;

  const MessageBubbleOverlay({
    super.key,
    required this.anchor,
    required this.child,
    required this.onDismiss,
  });

  @override
  State<MessageBubbleOverlay> createState() => _MessageBubbleOverlayState();
}

class _MessageBubbleOverlayState extends State<MessageBubbleOverlay> {
  final GlobalKey _bubbleKey = GlobalKey();

  /// Perkiraan tinggi sebelum pengukuran pertama selesai.
  static const double _estimatedHeight = 320;

  static const double _margin = 12;

  double _height = _estimatedHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;

    final box = _bubbleKey.currentContext?.findRenderObject() as RenderBox?;

    if (box == null || !box.hasSize) return;

    if (box.size.height == _height) return;

    setState(() => _height = box.size.height);
  }

  /// Area yang benar-benar terlihat: tinggi layar dikurangi keyboard yang
  /// sedang terbuka. Tanpa pengurangan ini gelembung bisa tertutup keyboard
  /// tepat di saat pengguna akan menekan aksinya.
  Rect get _visibleArea {
    final media = MediaQuery.of(context);

    return Rect.fromLTWH(
      0,
      0,
      media.size.width,
      media.size.height - media.viewInsets.bottom,
    );
  }

  Offset _positionFor(double height) {
    final area = _visibleArea;

    final lowestAllowed = _margin;
    final highestAllowed = (area.bottom - height - _margin).clamp(
      lowestAllowed,
      double.infinity,
    );

    // Bawaan: di atas titik yang ditekan, persis seperti iOS Messages.
    var top = widget.anchor.dy - height - _margin;

    if (top < lowestAllowed) {
      // Tidak muat di atas: dibalik ke bawah.
      top = widget.anchor.dy + _margin;
    }

    // Kalau dua-duanya tidak muat (pesan di tengah layar sempit), gelembung
    // dijepit ke dalam area terlihat. Lebih baik menumpuk sedikit daripada
    // tombol aksinya keluar layar dan tidak bisa ditekan.
    if (top > highestAllowed) {
      top = highestAllowed;
    }

    final width =
        _bubbleKey.currentContext?.size?.width ??
        MessageActionBubble.maxPanelWidth;

    var left = widget.anchor.dx - (width / 2);

    if (left < lowestAllowed) left = lowestAllowed;

    final rightLimit = area.right - _margin;

    if (left + width > rightLimit) left = rightLimit - width;

    if (left < lowestAllowed) left = lowestAllowed;

    return Offset(left, top);
  }

  @override
  Widget build(BuildContext context) {
    final position = _positionFor(_height);

    return Stack(
      children: [
        // Baris pertama: penutup seluruh layar. `opaque` wajib -- tanpa itu
        // GestureDetector hanya menangkap sentuhan yang jatuh tepat pada
        // willing-nya sendiri, sehingga sebagian besar ketukan tidak
        // menutup gelembung.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy,
          // Muncul dari kecil ke penuh dengan sedikit fade, sama seperti menu
          // kontekstual iOS. Tanpa ini gelembung tampil mendadak dan terasa
          // seperti dialog, bukan seperti menu.
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.92, end: 1),
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutBack,
                  builder: (context, value, child) => Opacity(
              opacity: value.clamp(0, 1),
              child: Transform.scale(scale: value, child: child),
            ),
            child: KeyedSubtree(key: _bubbleKey, child: widget.child),
          ),
        ),
      ],
    );
  }
}
