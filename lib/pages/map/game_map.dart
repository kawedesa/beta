// import 'dart:ui';

// import 'package:beta/pages/map/components/obstacle.dart';

// class GameMap {
//   String name;
//   List<Obstacle> obstacles;
//   GameMap({required this.name, required this.obstacles});

//   factory GameMap.newMap() {
//     return GameMap(
//       name: 'ruins',
//       obstacles: [
//         //BG
//         Obstacle(points: [
//           Offset(0, 0),
//           Offset(320, 0),
//           Offset(320, 320),
//           Offset(0, 320),
//         ]),
//         //Rock
//         Obstacle(points: [
//           Offset(252, 88),
//           Offset(255, 83),
//           Offset(261, 84),
//           Offset(265, 88),
//         ]),
//         //Totem
//         Obstacle(points: [
//           Offset(151, 252),
//           Offset(151, 247),
//           Offset(158, 241),
//           Offset(162, 245),
//           Offset(162, 250),
//           Offset(159, 252),
//         ]),
//         Obstacle(points: [
//           Offset(240, 272),
//           Offset(245, 272),
//           Offset(249, 274),
//           Offset(249, 281),
//           Offset(240, 282),
//           Offset(237, 277),
//         ]),
//         Obstacle(points: [
//           Offset(228, 222),
//           Offset(235, 229),
//           Offset(235, 234),
//           Offset(226, 234),
//           Offset(223, 232),
//           Offset(223, 224),
//         ]),
//         Obstacle(points: [
//           Offset(273, 238),
//           Offset(282, 240),
//           Offset(286, 245),
//           Offset(283, 250),
//           Offset(270, 250),
//           Offset(269, 247),
//         ]),
//         Obstacle(points: [
//           Offset(60, 177),
//           Offset(67, 170),
//           Offset(71, 170),
//           Offset(75, 177),
//         ]),
//         Obstacle(points: [
//           Offset(212, 58),
//           Offset(217, 50),
//           Offset(222, 50),
//           Offset(229, 42),
//           Offset(235, 42),
//           Offset(248, 54),
//           Offset(242, 56),
//           Offset(249, 65),
//           Offset(233, 66),
//           Offset(230, 61),
//           Offset(218, 61),
//           Offset(219, 58),
//         ]),
//         Obstacle(points: [
//           Offset(84, 235),
//           Offset(84, 219),
//           Offset(94, 217),
//           Offset(94, 187),
//           Offset(96, 185),
//           Offset(109, 185),
//           Offset(115, 173),
//           Offset(116, 162),
//           Offset(137, 159),
//           Offset(189, 177),
//           Offset(193, 209),
//           Offset(181, 220),
//           Offset(151, 212),
//           Offset(145, 224),
//           Offset(132, 235),
//         ]),
//         Obstacle(points: [
//           Offset(258, 208),
//           Offset(252, 214),
//           Offset(255, 220),
//           Offset(256, 224),
//           Offset(306, 230),
//           Offset(315, 228),
//           Offset(315, 208),
//           Offset(296, 178),
//           Offset(266, 177),
//           Offset(250, 193),
//         ]),
//         Obstacle(points: [
//           Offset(146, 137),
//           Offset(146, 145),
//           Offset(156, 145),
//           Offset(157, 147),
//           Offset(176, 147),
//           Offset(167, 137),
//           Offset(157, 138),
//           Offset(154, 138),
//           Offset(154, 130),
//           Offset(152, 127),
//           Offset(150, 130),
//           Offset(150, 137),
//           Offset(147, 137),
//         ]),
//         Obstacle(points: [
//           Offset(10, 304),
//           Offset(65, 305),
//           Offset(76, 320),
//           Offset(0, 320),
//           Offset(0, 154),
//           Offset(31, 156),
//           Offset(48, 167),
//           Offset(43, 182),
//           Offset(37, 182),
//           Offset(39, 188),
//           Offset(45, 191),
//           Offset(33, 192),
//           Offset(33, 203),
//           Offset(12, 210),
//         ]),
//         Obstacle(points: [
//           Offset(265, 112),
//           Offset(285, 112),
//           Offset(293, 122),
//           Offset(293, 132),
//           Offset(306, 142),
//           Offset(296, 150),
//           Offset(276, 150),
//           Offset(274, 152),
//           Offset(266, 151),
//           Offset(266, 146),
//           Offset(256, 145),
//           Offset(256, 133),
//           Offset(264, 125),
//         ]),
//         Obstacle(points: [
//           Offset(133, 320),
//           Offset(320, 320),
//           Offset(320, 280),
//           Offset(313, 282),
//           Offset(308, 290),
//           Offset(313, 300),
//           Offset(306, 304),
//           Offset(294, 315),
//           Offset(276, 310),
//           Offset(262, 310),
//           Offset(255, 305),
//           Offset(233, 309),
//           Offset(214, 291),
//           Offset(195, 298),
//           Offset(178, 290),
//           Offset(162, 310),
//           Offset(142, 308),
//         ]),
//         Obstacle(points: [
//           Offset(320, 63),
//           Offset(309, 64),
//           Offset(300, 75),
//           Offset(280, 75),
//           Offset(277, 73),
//           Offset(268, 73),
//           Offset(272, 69),
//           Offset(267, 68),
//           Offset(260, 62),
//           Offset(260, 52),
//           Offset(275, 40),
//           Offset(274, 16),
//           Offset(196, 15),
//           Offset(178, 48),
//           Offset(185, 54),
//           Offset(163, 59),
//           Offset(156, 64),
//           Offset(142, 66),
//           Offset(135, 52),
//           Offset(117, 52),
//           Offset(102, 60),
//           Offset(114, 70),
//           Offset(114, 78),
//           Offset(110, 78),
//           Offset(111, 82),
//           Offset(108, 88),
//           Offset(51, 87),
//           Offset(48, 81),
//           Offset(29, 77),
//           Offset(10, 63),
//           Offset(0, 63),
//           Offset(0, 0),
//           Offset(320, 0),
//         ]),
//       ],
//     );
//   }

//   Path seeObstacles() {
//     Path visibleObstacles = Path();

//     for (Obstacle obstacle in obstacles) {
//       visibleObstacles.addPolygon(obstacle.points, true);
//     }

//     return visibleObstacles;
//   }
// }
