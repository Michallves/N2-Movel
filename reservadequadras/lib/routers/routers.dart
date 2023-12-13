import 'package:go_router/go_router.dart';
import 'package:reservadequadras/pages/add_reservation_page.dart';
import 'package:reservadequadras/pages/edit_reservation.dart';
import 'package:reservadequadras/pages/home_page.dart';

final routers = GoRouter(
  initialLocation: '/reservations',
  routes: <GoRoute>[
    GoRoute(
        path: '/reservations',
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => AddReservationPage(),
          ),
                    GoRoute(
              path: ':id/edit',
              builder: (context, state) =>
                  EditReservationPage(id: state.extra as int),
            ),
        ])
  ],
);
