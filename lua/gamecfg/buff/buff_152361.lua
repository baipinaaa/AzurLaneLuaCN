return {
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 2,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
					end
				}
			},
			{
				id = 3,
				type = "BattleBuffShieldWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "shield05",
					count = 2,
					bulletType = 3,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 - 2.512

						return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 100,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 100,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 100,
					attack_attribute = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								1.02,
								0,
								1.22
							}
						}
					},
					centerPosFun = function (slot0)
						slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
					end,
					rotationFun = function (slot0)
						return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	init_effect = "",
	name = "",
	time = 10,
	picture = "",
	desc = "守卫之盾",
	stack = 1,
	id = 152361,
	icon = 152361,
	last_effect = "",
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3

					return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 2,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3 + 2.512

					return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
				end
			}
		},
		{
			id = 3,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 2,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3 - 2.512

					return Vector3(math.sin(slot1) * 3, 0.75, math.cos(slot1) * 3)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
				end
			}
		},
		{
			id = 4,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3

					return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 5,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

					return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
				end
			}
		},
		{
			id = 6,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function (slot0)
					slot1 = slot0 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

					return Vector3(math.sin(slot1) * 8, 0.75, math.cos(slot1) * 8)
				end,
				rotationFun = function (slot0)
					return Vector3(0, slot0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
				end
			}
		}
	}
}
