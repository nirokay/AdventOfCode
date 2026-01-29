# Advent of Code

This repository houses my solutions to the [Advent of Code](https://adventofcode.com) programming challenges.

## Completion

| Year | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 |
|:----:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 2022 | ** | ** | ** | ** | ** | ** | ** | *  | *  | *  |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
| 2024 | ** | ** | ** | ** | ** | ** | ** | ** | ** | ** |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
| 2025 | *  | ** | *  | ** | *  | *  | *  |    | *  |    |    |    | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |

> **Legend:**
> * `* ` only part 1 completed
> * `**` both parts 1 and 2 completed
> * `  ` not (yet) attempted / no part completed
> * `--` does not exist

## Running

From root directory:
```bash
# Format:
$ ./runner.sh $YEAR $DAY

# Example:
$ ./runner.sh 2025 04
```

## Getting inputs

Insert your session id into a file named `.session-id` (Firefox instructions):
  * Open Inspect
  * Navigate to **Storage**
  * Open **Cookies**
  * Copy value of `session` cookie

From root directory:
```bash
# Format:
$ ./get-input.sh $YEAR $DAY       # specific day
$ ./get-input-for-a-year.sh $YEAR # all days of a year

# Example:
$ ./get-input.sh 2025 04
$ ./get-input-for-a-year.sh 2025
```

## Licence

Code available here is licensed under [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).
