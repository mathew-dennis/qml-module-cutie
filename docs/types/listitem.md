---
title: CutieListItem QML Type
---

CutieListItem is a selectable list item styled to fit Cutie UI visual language.

Inherits: QtQuick.Controls 2.15 Button

### Properties

- [subText](#subtext): string
- [iconOverlay](#iconoverlay): bool
- [wrapMode](#wrapmode): int
- [elide](#elide): int
- [maximumLineCount](#maximumlinecount): int
- [menu](#menu): [CutieMenu](menu)

## Detailed Description

Extends QtQuick.Controls 2 Button to function as a selectable item in [ListViews](listview) and to fit Cutie UI. It supports adding context menus easily by using its `menu` property and `CutieMenu` QML type.

## Property Documentation

#### subText

string

An optional text shown below the actual text in the `text` property. By default, this is shown using a smaller font size than the main text.

#### iconOverlay

bool

If true, filters the icon to be colored black or white depending on the atmosphere variant. By default, this is set to true.

#### wrapMode

int

Set this property to wrap the `text` and `subText` to the item's width. The text will only wrap if an explicit width has been set. Accepts standard QML `Text` wrap modes (e.g., `Text.Wrap`, `Text.NoWrap`). By default, this is set to `Text.Wrap`.

#### elide

int

Set this property to elide parts of the `text` and `subText` if they do not fit within the item's width. Accepts standard QML `Text` elide modes (e.g., `Text.ElideRight`, `Text.ElideNone`). By default, this is set to `Text.ElideNone`.

#### maximumLineCount

int

Set this property to limit the number of lines that the `text` and `subText` will span. By default, this is set to `-1` (no limit).

#### menu

[CutieMenu](menu)

Can be set to add a context menu that will pop up on the `pressAndHold` signal.