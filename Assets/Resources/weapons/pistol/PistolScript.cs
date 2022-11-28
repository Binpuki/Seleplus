using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Seleplus.Scripts;

namespace Seleplus.Objects.Weapons
{
    public class PistolScript : RangedWeapon
    {
        [SerializeField] private GameObject Bullet;

        public override void Shoot()
        {
            base.Shoot();

            var bullet = Instantiate(Bullet);
            bullet.GetComponent<Bullet>().Setup(gunBarrel.position, FindObjectOfType<MouseTracker>().worldPosition, angleDegrees);
        }
    }
}