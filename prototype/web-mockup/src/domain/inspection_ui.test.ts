import test from 'node:test';
import assert from 'node:assert/strict';
import {
  normalizeHeading,
  headingToDirection,
  turnDelta,
  turnGuidance,
} from './inspection_ui.ts';

test('normalizeHeading wraps into 0~359', () => {
  assert.equal(normalizeHeading(360), 0);
  assert.equal(normalizeHeading(-90), 270);
  assert.equal(normalizeHeading(725), 5);
});

test('headingToDirection returns 16-point Chinese direction', () => {
  assert.equal(headingToDirection(0), '北');
  assert.equal(headingToDirection(90), '東');
  assert.equal(headingToDirection(285), '西北西');
  assert.equal(headingToDirection(355), '北');
});

test('turnDelta picks the shortest turn across north', () => {
  assert.equal(turnDelta(350, 10), 20);
  assert.equal(turnDelta(10, 350), -20);
  assert.equal(turnDelta(90, 285), -165);
  assert.equal(turnDelta(0, 180), 180);
});

test('turnGuidance tells user which way to turn until aligned', () => {
  assert.equal(turnGuidance(90, 285).text, '往左轉約 165°');
  assert.equal(turnGuidance(270, 285).aligned, true);
  assert.equal(turnGuidance(200, 285).text, '往右轉約 85°');
});
