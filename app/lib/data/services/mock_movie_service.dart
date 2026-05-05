import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/models/user_profile.dart';

/// In-memory mock data – replace with real API calls when the backend is ready.
abstract final class MockMovieService {
  static const String _base = 'https://lh3.googleusercontent.com/aida-public';

  static final List<Movie> allMovies = [
    Movie(
      id: 'citizen_kane',
      title: 'Citizen Kane',
      year: 1941,
      duration: 119,
      rating: 8.3,
      genres: ['Drama', 'Mystery'],
      director: 'Orson Welles',
      ageRating: 'G',
      synopsis:
          'When a reporter is assigned to decipher newspaper magnate Charles Foster Kane\'s dying words, his investigation gradually reveals the fascinating portrait of a complex man who rose from poverty to world prominence.',
      posterUrl:
          '$_base/AB6AXuArZvR2IzHhPlgEjGOq9lWK5G-dxxPGQu3nu6i_XkJ0IQpuQP2SO8qyVvE6Ec6ifi4fGDQNfCEU0qvICqS8-WNXXN-Yuwt_JVVhWL7wGfX4wQZQPb1bKbfa6tXvxQ8XzSh2_Ca1wyZmNTXiUxNHoPXcmuCEpcU5KhvC-0qeBULBEJA4XdiRWSzXc7njJ7ZOZigHXvm0DiH8L5ZLmynGtZaaJGeTIp2QhNRqa8vNlcGfnMPwKUWjELrzHVKCJ2MFbTXf8ggO5rmCEAw',
      backdropUrl:
          '$_base/AB6AXuCJ7es-tbNm0WD-ozf9WgKotX_F2e1vCl-8z4cOeFi37wRJeTEMZzUFYEHuMFUhrK3Kn7YlBHKHRk_zdJOY_zJxgB4U3OkHtaZUNnNPN4U5S4nzbOglNzpWBZJTXDdrQiD6uqgZJWMWovinaSuCYNjTocgoszmR7NWGPButKwg7pRy2Ma0X9XSdde0DyzYEx9E-LFdeo0R4kDyAxVRmDs2B4mwZ1TdcLxsgeJtXyFw2k_UNGk9pYH0c3j3EUqR0ZHbe5aqu0Z5ERMU',
      cast: const [
        CastMember(
          name: 'Orson Welles',
          character: 'Charles Foster Kane',
          photoUrl:
              '$_base/AB6AXuBiDtt0YaJZmhn9U6BPzoUDP89MXqnsrZJPKfFGKkJxiLwP6KrEA2bKepz9Mhm3P6Eoo1bP5HcPH0Q3q5g9Tt298ciQBpiMi3DlfIiN7xeocYQjiizrnEveHccvB0ML6Qj6Ie5zucKVDlXALeCCckL2S47XLyBvb7mUI0wHPA_fHlyG_ScpUPQ0qvhWTp5fF91yBFmetpQDDLp6dfUPpgHk-oMkKqn2mXFUP2_eF058pLnTi18xiWtz1SJ3h2BxbasH8zXmzyNDZL4',
        ),
      ],
    ),
    Movie(
      id: 'godfather',
      title: 'The Godfather',
      year: 1972,
      duration: 175,
      rating: 9.2,
      genres: ['Crime', 'Drama'],
      director: 'Francis Ford Coppola',
      ageRating: 'R',
      synopsis:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      posterUrl:
          '$_base/AB6AXuAVRByZh7To0_6Bk4vwDiKDhm1HMDNfEQQ6pexrHCghFsbvVgxg0bRivVxdT8aDeUXtOKmUprsyXTg2T3rKx_gLfj4AtoZ8uge9GJwcPGYepJ3jpSkASlSZnZsqrZCACyUHeAmlXKPvcrRzo-F-BqRRbU6bu0ei4FlndtLGHoG9yzP1h6tznhb7ECIvAD7bepwd2lpiDTlWEk5G9b9VZ0wHc4aRstgGYD-bQ5fdwSbGaQEwR0nNRd35eEEXcsCksNeCgqxxbkMr2N4',
      backdropUrl:
          '$_base/AB6AXuCXW68a8GbpNpHnJHMbyRm7txnQtIgC_Ep32vn4wnDIpFLg7HSDukgJ0fHK6SpJkqefoD4R69HogTTHNXR0AKQDm4gsCnXGxyzcXaiYm3OZwUpTMQkL8g4BHk0-5JKS_CqvkMhG4uq5Cj8LDLCWMdAylpAY3fJkz0D1QcR-6Rs-ufpTrBJzCA7mQyinyy3-3iTJy-07nDOunI431sx1TRfBMvU8G5k4cLR6m6ZYqOFQL3pyEQ5pR7syU4IVcyiZGm3klqBaThr7okg',
      cast: const [
        CastMember(
          name: 'Marlon Brando',
          character: 'Don Vito Corleone',
          photoUrl:
              '$_base/AB6AXuBiDtt0YaJZmhn9U6BPzoUDP89MXqnsrZJPKfFGKkJxiLwP6KrEA2bKepz9Mhm3P6Eoo1bP5HcPH0Q3q5g9Tt298ciQBpiMi3DlfIiN7xeocYQjiizrnEveHccvB0ML6Qj6Ie5zucKVDlXALeCCckL2S47XLyBvb7mUI0wHPA_fHlyG_ScpUPQ0qvhWTp5fF91yBFmetpQDDLp6dfUPpgHk-oMkKqn2mXFUP2_eF058pLnTi18xiWtz1SJ3h2BxbasH8zXmzyNDZL4',
        ),
        CastMember(
          name: 'Al Pacino',
          character: 'Michael Corleone',
          photoUrl:
              '$_base/AB6AXuCgfuHUk-haejCQOstxE1jxtQalBMyL8rYWZTnbRgvxeayVNlzNvz2CyU7n5XpwbwQZjzKcmCuPkpGS_972Bj1aCg8HrcbgYbSlzSCRaAUaT3xNA2QPTgh3Ve0QoLLr22wA3WhN58-tlgwSGeKdfK4Zc0bvVi2QSQXRE3X9UV8RUSV2utemQt163-O2EO45F9JTCkHr9z9FaK7YpY44DCW2_r2ENITjFM0Lh30z2nFP6t6nEb9tu5eUOL4DCnActIFZH3MViWQP6Cg',
        ),
        CastMember(
          name: 'James Caan',
          character: 'Sonny Corleone',
          photoUrl:
              '$_base/AB6AXuAEgyBbvgOF_WbVzZFjMme8rq0jmlt5YqSGhkyWU8JN-CP2w4e3xGoB0CJcOrbm3aaBm460sw4NdJ311_-vSIAE0YMK8ULJvSg8pU21uzYSSgpkVW3Z9xmvvvJ79oAmEUqA4VAsxdP9_pPGmFyz20MkcrD0iONbfJFbqNmzMuw78glhsklID4Xt76Qbis7fxJk6uyGTQZcl4LS2WWE70itfX9opYsa1D-QxGDRlGE-THJsinPWCQDKGrDcJA1jS8Y5Ywk30HZ6rRDk',
        ),
        CastMember(
          name: 'Diane Keaton',
          character: 'Kay Adams',
          photoUrl:
              '$_base/AB6AXuBtBq2Ud4R17SlFFNcPe_-llS2xVrdsxHLfystI4fEZHZsok7A6ry36ZZrkfuTjZl7dH83EW9KRUPsRVe25E9XDeFPYPWByeo407nxmp26LfaOA0UVFXqNtZNlekyeDhQdta9BtVzbI5UruKOi7TyWnhkjGLm9q9jQIjKNvDneEfwixEfGCGJW8T_2sHDv5lBKlgmt5h-2loxHHIsTC9f87qg0xuEvh-NQAnMUEQ2HeAmb4-aPIW4OyQWy7842l_A92CGSmciYxJr4',
        ),
      ],
    ),
    Movie(
      id: 'vertigo',
      title: 'Vertigo',
      year: 1958,
      duration: 128,
      rating: 8.3,
      genres: ['Mystery', 'Thriller'],
      director: 'Alfred Hitchcock',
      ageRating: 'PG',
      synopsis:
          'A former San Francisco police detective, rendered acrophobic by a traumatic incident, is hired to shadow a mysterious woman.',
      posterUrl:
          '$_base/AB6AXuArZvR2IzHhPlgEjGOq9lWK5G-dxxPGQu3nu6i_XkJ0IQpuQP2SO8qyVvE6Ec6ifi4fGDQNfCEU0qvICqS8-WNXXN-Yuwt_JVVhWL7wGfX4wQZQPb1bKbfa6tXvxQ8XzSh2_Ca1wyZmNTXiUxNHoPXcmuCEpcU5KhvC-0qeBULBEJA4XdiRWSzXc7njJ7ZOZigHXvm0DiH8L5ZLmynGtZaaJGeTIp2QhNRqa8vNlcGfnMPwKUWjELrzHVKCJ2MFbTXf8ggO5rmCEAw',
      backdropUrl:
          '$_base/AB6AXuAMl8HZEka5QbzzxzTjmBbMmiUcSc8de8bI5hM9I5QLbOjAOzf-0iF3k5ujPNy-PtNf_y6ovuqncB0Wi25ZbNn0lJMSf0C-v9Xrmly-H95wxJWpWDW2k4TVmzDL6W9u6RTePYllQ65dp9r9O8vbbWQKAnDMJvcX1wMhjzvG6qN6zstHGz06ryoVSdYHsGINSGb67-P6HU4yKgX-IDuoPPVw-qXnsKoMJ1lSg8mh01YxJOYTyiesX8bVYbt0-Ruzlp0sBiATBVcv-ew',
      cast: const [],
    ),
    Movie(
      id: 'psycho',
      title: 'Psycho',
      year: 1960,
      duration: 109,
      rating: 8.5,
      genres: ['Horror', 'Thriller'],
      director: 'Alfred Hitchcock',
      ageRating: 'R',
      synopsis:
          'A secretary embezzles forty thousand dollars from her employer\'s client and checks into a remote motel run by a young man under the domination of his mother.',
      posterUrl:
          '$_base/AB6AXuAw4IV6vhujLlXNKAWN3ueFxGB6IKayWXZF0ZrmvT9xWCAMA2NkiWadjZCxw-4sN-1bg5Tsdq6AYsTTiUzgc6FkCERiGDCMvCFEve3Uz39BRIMfH9qWHYfGblDdLz_l5oRngqzOHi7kV2GsDaswjQL6T-CwFljwLsp43HKXYj-U0XXHi0g7SkcT4_NvFU4fIT1jvn_bdyKBn9iziBBizrk60mqdYQY9ZuFU7iorBRkvdfqXKKuuuH1dhZvbk1Geu_olP3mFGU5toW4',
      backdropUrl:
          '$_base/AB6AXuATLwfCmDH63Uw8n8XFbsd7GTZGWwHdrQTguW2cwzXHNsg9J0VQD0p4tF10uo7WedGMU68aitlSAeaQvGRZOPoDJqb2F_gwuXl1ifCAs4dIChPm_vxElOK5mNIKU6ht9geHsGdXfysUgKea34nGynavdcCC03jjcgzNZHrbx6OtcwpOh9whFKY65V00JvKqRSuD9lP14YRGqVP2u8189gxqMr9RcwGkxA-7kH38hdEy73OrGGEvK2Z7Zs-Tr-xnsqgsHM_UVvVdTPs',
      cast: const [],
    ),
    Movie(
      id: '12_angry_men',
      title: '12 Angry Men',
      year: 1957,
      duration: 96,
      rating: 9.0,
      genres: ['Drama', 'Crime'],
      director: 'Sidney Lumet',
      ageRating: 'G',
      synopsis:
          'The jury in a New York City murder trial is frustrated by a single member who prevents them from reaching a quick guilty verdict.',
      posterUrl:
          '$_base/AB6AXuBCvmy-y28G_CXJ91lsIf866ac6ACiLsFw2TTQkfzs-C94CMzI93u6__VdZrnroUNPVwezLxjApJlp9ENuDlw4KqVJRTECP0WfaxScE7EznPzLsAM9w2ert-PoQ0q9vpz3b8O9iHz-EUaZKNzMqPY6g0bMs1cPhWi32-UWvbe5CWMb0WyW9whOB04moBc0-sPuQffP4cmJiZAqEra7V-LYiD_GiXyH1M5gJp8PvDnyoKapvlU-B8dmTaKw0V46oPDat5MNQOyJVAEM',
      backdropUrl:
          '$_base/AB6AXuAa5kQrE3XXLCZXCe3xUDYSVST_XwK0_Qr2H-P1BoBYX7bKNH7mw1ThF1V8OQpqw1vq2uRqJr6SeLnzqRyw9umVZv26Uae7EB1Th7gRiabd-uaHiE9A2gTm1eAg2uQMn-rGSS_hI1XNEh6Z6x-RNZiX5MdSA4hNGlC4kH7wzz4H2Gl90yUHiw3n2N3d014DpXrVs3A0QTjm6y0zAXpCDlCPcT4Ng1oC6Qeenqns9GRainnWVDE6JJfJXp1FtIwjJsUOqoTn0YPL_qI',
      cast: const [],
    ),
    Movie(
      id: 'goodfellas',
      title: 'Goodfellas',
      year: 1990,
      duration: 146,
      rating: 8.7,
      genres: ['Crime', 'Drama'],
      director: 'Martin Scorsese',
      ageRating: 'R',
      synopsis:
          'The story of Henry Hill and his life in the mob, covering his journey from childhood through adulthood.',
      posterUrl:
          '$_base/AB6AXuAVRByZh7To0_6Bk4vwDiKDhm1HMDNfEQQ6pexrHCghFsbvVgxg0bRivVxdT8aDeUXtOKmUprsyXTg2T3rKx_gLfj4AtoZ8uge9GJwcPGYepJ3jpSkASlSZnZsqrZCACyUHeAmlXKPvcrRzo-F-BqRRbU6bu0ei4FlndtLGHoG9yzP1h6tznhb7ECIvAD7bepwd2lpiDTlWEk5G9b9VZ0wHc4aRstgGYD-bQ5fdwSbGaQEwR0nNRd35eEEXcsCksNeCgqxxbkMr2N4',
      backdropUrl:
          '$_base/AB6AXuCXW68a8GbpNpHnJHMbyRm7txnQtIgC_Ep32vn4wnDIpFLg7HSDukgJ0fHK6SpJkqefoD4R69HogTTHNXR0AKQDm4gsCnXGxyzcXaiYm3OZwUpTMQkL8g4BHk0-5JKS_CqvkMhG4uq5Cj8LDLCWMdAylpAY3fJkz0D1QcR-6Rs-ufpTrBJzCA7mQyinyy3-3iTJy-07nDOunI431sx1TRfBMvU8G5k4cLR6m6ZYqOFQL3pyEQ5pR7syU4IVcyiZGm3klqBaThr7okg',
      cast: const [],
    ),
    Movie(
      id: 'seventh_seal',
      title: 'The Seventh Seal',
      year: 1957,
      duration: 96,
      rating: 8.1,
      genres: ['Drama', 'Fantasy'],
      director: 'Ingmar Bergman',
      ageRating: 'PG',
      synopsis:
          'A medieval knight returning from the Crusades challenges Death to a game of chess to delay dying.',
      posterUrl:
          '$_base/AB6AXuDRUxPLGHK_nYXs8R0HJZvDyf8nisdtwmSUalkhemnzyOoEhce1PKdS44cq-_KFKUc7ZxrKbACQhHh_ALkRqNBSSgaQWIR-PTQal_TpVjDCxe1G9MDg1EmBlNtIMS4IZ2JwLCB1BnATKSh12nqgKwOCssZVnlDODkXF6xz39q0gzl6CQPiItq6oyHNe1WjODFFydgsIdt6vqPtO2BtD1YFMkmZHRcuBis6qZr6InhPkwC6s7zieEt-2F9UFAvr0XCUJnf4cU3Uzssg',
      backdropUrl:
          '$_base/AB6AXuAMl8HZEka5QbzzxzTjmBbMmiUcSc8de8bI5hM9I5QLbOjAOzf-0iF3k5ujPNy-PtNf_y6ovuqncB0Wi25ZbNn0lJMSf0C-v9Xrmly-H95wxJWpWDW2k4TVmzDL6W9u6RTePYllQ65dp9r9O8vbbWQKAnDMJvcX1wMhjzvG6qN6zstHGz06ryoVSdYHsGINSGb67-P6HU4yKgX-IDuoPPVw-qXnsKoMJ1lSg8mh01YxJOYTyiesX8bVYbt0-Ruzlp0sBiATBVcv-ew',
      cast: const [],
    ),
    Movie(
      id: 'bicycle_thieves',
      title: 'Bicycle Thieves',
      year: 1948,
      duration: 89,
      rating: 8.3,
      genres: ['Drama'],
      director: 'Vittorio De Sica',
      ageRating: 'G',
      synopsis:
          'In post-World War II Italy, a man who has finally found work has his bicycle stolen and must find it to keep his job.',
      posterUrl:
          '$_base/AB6AXuCcl0-h4BDPXzajVvVj85Z0DgqTppHbOA2HiwebeAg3Fo-P55j01L-lZiAmMEk-Vyjk2HmfOS2VgaJGGN5m-mTo6qB4yjnLQ22LQ-a9YcKcCfGTCSbwjlFqfHb8siDWJZ2seNr_f0LIo-zc0o0YpxpKLsseuJpGd9o5BIINpZnxpEe9Im__mdeTjqOs0TA1VMHI7G636faI7PrD4fG3UuYES4GD6rwcWPKJ0lEY5O-Njf4xtsPaDbKt9tStaKqtQ36eIjpLYAdemPc',
      backdropUrl:
          '$_base/AB6AXuAMl8HZEka5QbzzxzTjmBbMmiUcSc8de8bI5hM9I5QLbOjAOzf-0iF3k5ujPNy-PtNf_y6ovuqncB0Wi25ZbNn0lJMSf0C-v9Xrmly-H95wxJWpWDW2k4TVmzDL6W9u6RTePYllQ65dp9r9O8vbbWQKAnDMJvcX1wMhjzvG6qN6zstHGz06ryoVSdYHsGINSGb67-P6HU4yKgX-IDuoPPVw-qXnsKoMJ1lSg8mh01YxJOYTyiesX8bVYbt0-Ruzlp0sBiATBVcv-ew',
      cast: const [],
    ),
  ];

  static const UserProfile currentUser = UserProfile(
    id: 'user_1',
    displayName: 'Sarah Jenkins',
    avatarUrl:
        '$_base/AB6AXuB2P4vjL0H1AapFYgA340E3ApfWHLYNCA32a-t85jkb4c9DPGnM9l7ZPZgcqzLZ0T1WTj01RLVMG61SyLLfGGpF3jd4HGSjWdsJormji6Q-cHPjo0S2o7GkZ4tMHSbmWOV0IFTuGTZZ2SWvSqUl9bHdQUfIk2F2PHe7eyK7XaYKf5LHP0Djk5RixLH7zWEGBlBADyRuKgpIPC0hMpXik0AXTH12eVrElEqY8tr8A6rNZjthUos01b2-LQqJj1pQR7rwRyc8WPDf4Eo',
    moviesWatched: 142,
    memberSince: 2018,
    watchlistIds: ['godfather', 'vertigo', 'psycho', '12_angry_men'],
  );
}
