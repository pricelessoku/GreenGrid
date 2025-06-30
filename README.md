# GreenGrid - Renewable Energy Production Tracking System

A blockchain-based renewable energy production tracking and incentive platform built on Stacks, promoting clean energy adoption through transparent monitoring and rewards.

## Overview

GreenGrid enables renewable energy producers to track their clean energy generation across approved source types while earning incentives based on production contributions, accelerating the transition to sustainable energy.

## Features

- Renewable energy production logging with source verification
- Approved energy source management system
- Green incentive calculation and distribution
- Transparent production tracking and rewards
- Grid administrator oversight and governance

## Smart Contract Functions

### Public Functions
- `initialize-green-grid`: Initialize renewable energy tracking system
- `approve-energy-source`: Approve renewable energy source types
- `record-energy-production`: Record energy production with source type
- `process-green-incentives`: Process green energy incentives
- `claim-energy-incentives`: Claim renewable energy incentives

### Read-Only Functions
- `get-producer-generation`: Get producer's total energy generation
- `get-energy-source-type`: Get producer's energy source type
- `get-total-energy-produced`: Get total renewable energy produced
- `is-energy-source-approved`: Check energy source approval status

## Usage

Deploy the contract and initialize with a grid administrator. Approve renewable energy sources, then producers can record generation and claim incentives based on their contributions.

## Security

- Grid administrator authorization controls
- Energy source approval system for verified tracking
- Input validation for all energy production entries
- Production verification before incentive distribution