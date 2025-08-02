from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel
from functools import wraps
from typing import List, Optional, Callable

app = FastAPI()

# ---------- 数据模型定义 ----------
class User(BaseModel):
    id: int
    username: str
    roles: List[str]  # 用户拥有的角色列表

class Permission(BaseModel):
    name: str
    description: str

# ---------- RBAC 存储 ----------
# 模拟数据库存储
ROLE_PERMISSIONS = {
    "admin": ["content.create", "content.delete", "user.manage"],
    "editor": ["content.create", "content.edit"],
    "viewer": ["content.read"]
}

USERS_DB = {
    1: User(id=1, username="admin", roles=["admin"]),
    2: User(id=2, username="editor", roles=["editor"]),
    3: User(id=3, username="viewer", roles=["viewer"])
}

# ---------- 核心装饰器 ----------
def has_permission(required_permissions: List[str]):
    """
    RBAC权限控制装饰器
    :param required_permissions: 访问端点所需的权限列表
    """
    def decorator(func: Callable):
        @wraps(func)
        async def wrapper(
            user: User = Depends(get_current_user),  # 依赖注入当前用户
            *args, **kwargs
        ):
            # 获取用户所有权限
            user_permissions = set()
            for role in user.roles:
                if role in ROLE_PERMISSIONS:
                    user_permissions.update(ROLE_PERMISSIONS[role])

            # 检查是否拥有所有必需权限
            missing_perms = [perm for perm in required_permissions
                             if perm not in user_permissions]

            if missing_perms:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail=f"缺少权限: {', '.join(missing_perms)}"
                )

            return await func(user, *args, **kwargs)
        return wrapper
    return decorator

# ---------- 依赖项 ----------
async def get_current_user(user_id: int = 1) -> User:  # 简化认证，实际应从token获取
    """模拟获取当前用户"""
    user = USERS_DB.get(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="用户不存在"
        )
    return user

# ---------- API 端点 ----------
@app.get("/admin/dashboard")
@has_permission(required_permissions=["user.manage"])
async def admin_dashboard(user: User):
    return {"message": f"欢迎管理员 {user.username}", "data": "敏感管理数据"}

@app.post("/content")
@has_permission(required_permissions=["content.create"])
async def create_content(user: User, content: str):
    return {"message": "内容创建成功", "author": user.username}

@app.put("/content/{content_id}")
@has_permission(required_permissions=["content.edit"])
async def update_content(content_id: int, user: User):
    return {"message": f"内容 {content_id} 已更新", "editor": user.username}

@app.get("/content")
@has_permission(required_permissions=["content.read"])
async def read_content(user: User):
    return {"message": "公开内容列表", "viewer": user.username}

@app.delete("/content/{content_id}")
@has_permission(required_permissions=["content.delete"])
async def delete_content(content_id: int, user: User):
    return {"message": f"内容 {content_id} 已删除", "operator": user.username}

# ---------- 测试端点 ----------
@app.get("/my-permissions")
async def check_permissions(user: User = Depends(get_current_user)):
    """查看当前用户权限"""
    permissions = []
    for role in user.roles:
        permissions.extend(ROLE_PERMISSIONS.get(role, []))
    return {"username": user.username, "roles": user.roles, "permissions": list(set(permissions))}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
